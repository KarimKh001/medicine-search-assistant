import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medicine.dart';

/// Which openFDA field(s) a search term is matched against.
///
/// [all] preserves the original "search everywhere" behavior (brand OR
/// generic OR substance). The others scope the query to exactly one
/// harmonized field, per the brand/generic/ingredient filter.
enum SearchField { all, brand, generic, ingredient }

/// Common values of openFDA's `openfda.route` field (route of
/// administration). This is the closest harmonized field the `drug/label`
/// endpoint exposes to "dosage form" -- there is no dedicated
/// `dosage_form` field on this endpoint (that only exists on other openFDA
/// endpoints like `drug/ndc.json`), so this filter is route-based rather
/// than true tablet/capsule/cream granularity.
const List<String> kOpenFdaRoutes = [
  'ORAL',
  'TOPICAL',
  'INTRAVENOUS',
  'INTRAMUSCULAR',
  'SUBCUTANEOUS',
  'OPHTHALMIC',
  'NASAL',
  'RECTAL',
  'VAGINAL',
  'TRANSDERMAL',
  'SUBLINGUAL',
  'INHALATION',
  'DENTAL',
  'OTIC',
];

/// Thin wrapper around the public openFDA Drug Label API.
///
/// openFDA is a free, public, no-API-key-required government API
/// (https://open.fda.gov/apis/drug/label/), which satisfies requirement 1:
/// "Use a public API to get the medicines".
///
/// Note: openFDA label records do not include product photos, which is
/// exactly why requirement 2 (web image search fallback) exists.
class MedicineApiService {
  static const _host = 'api.fda.gov';
  static const _path = '/drug/label.json';

  /// Searches openFDA by brand name, generic name, or active substance and
  /// maps the raw JSON into our [Medicine] model. Returns an empty list on
  /// no matches.
  ///
  /// Two bugs used to cut the result count down a lot compared to a plain
  /// "search this term" experience:
  ///  1. The query was built as a raw string with a literal `+` glued
  ///     between the two field clauses (`"x"+openfda.generic_name:"y"`)
  ///     and passed straight into `Uri.parse`. `+` in a query string is
  ///     ambiguous (some layers treat it as a literal plus, others decode
  ///     it as a space), and with no whitespace around it the FDA query
  ///     parser could easily fail to split it into two separate clauses at
  ///     all -- silently falling back to matching almost nothing. Building
  ///     the query with `Uri.https(...)` lets Dart percent-encode it
  ///     correctly instead.
  ///  2. It only searched `brand_name` and `generic_name`, missing
  ///     `substance_name` (how a lot of generic/OTC drugs are actually
  ///     indexed), and capped results at 15. openFDA supports up to 1000
  ///     results per request, so 15 was leaving most matches unseen.
  Future<List<Medicine>> search(
    String query, {
    int limit = 50,
    SearchField field = SearchField.all,
    String? route,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    String fieldClause;
    switch (field) {
      case SearchField.brand:
        fieldClause = 'openfda.brand_name:"$trimmed"';
        break;
      case SearchField.generic:
        fieldClause = 'openfda.generic_name:"$trimmed"';
        break;
      case SearchField.ingredient:
        fieldClause = 'openfda.substance_name:"$trimmed"';
        break;
      case SearchField.all:
        fieldClause = 'openfda.brand_name:"$trimmed" '
            'OR openfda.generic_name:"$trimmed" '
            'OR openfda.substance_name:"$trimmed"';
        break;
    }

    // openFDA parses bare "OR" clauses correctly when wrapped in
    // parentheses and ANDed with an additional filter clause.
    final trimmedRoute = route?.trim() ?? '';
    final search = trimmedRoute.isEmpty
        ? fieldClause
        : '($fieldClause) AND openfda.route:"$trimmedRoute"';

    final uri = Uri.https(_host, _path, {
      'search': search,
      'limit': '$limit',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    // openFDA returns 404 (not 200 + empty array) when there are no matches.
    if (response.statusCode == 404) {
      return [];
    }
    if (response.statusCode != 200) {
      throw MedicineApiException(
        'openFDA request failed with status ${response.statusCode}',
      );
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    final List results = body['results'] ?? [];

    return results.map(_mapResultToMedicine).toList();
  }

  Medicine _mapResultToMedicine(dynamic raw) {
    final Map<String, dynamic> result = raw as Map<String, dynamic>;
    final Map<String, dynamic> openfda =
        (result['openfda'] as Map<String, dynamic>?) ?? {};

    String firstOrEmpty(dynamic list) {
      if (list is List && list.isNotEmpty) return list.first.toString();
      return '';
    }

    final brand = firstOrEmpty(openfda['brand_name']);
    final generic = firstOrEmpty(openfda['generic_name']);
    final name = brand.isNotEmpty ? brand : generic;
    final manufacturer = firstOrEmpty(openfda['manufacturer_name']);
    final route = firstOrEmpty(openfda['route']);
    final productType = firstOrEmpty(openfda['product_type']);
    final dosageForm = route.isNotEmpty ? route : productType;
    final substance = firstOrEmpty(openfda['substance_name']);

    final description = firstOrEmpty(result['description']).isNotEmpty
        ? firstOrEmpty(result['description'])
        : firstOrEmpty(result['indications_and_usage']).isNotEmpty
            ? firstOrEmpty(result['indications_and_usage'])
            : firstOrEmpty(result['purpose']);

    return Medicine(
      name: name.isEmpty ? 'Unknown' : name,
      manufacturer: manufacturer,
      dosageForm: dosageForm,
      description: _truncate(description, 400),
      imageUrl: null, // openFDA never returns photos
      imageSource: ImageSource.none,
      apiSourceId: (result['id'] ?? '${name}_$manufacturer').toString(),
      substanceName: substance,
    );
  }

  String _truncate(String text, int maxChars) {
    if (text.length <= maxChars) return text;
    return '${text.substring(0, maxChars).trimRight()}...';
  }
}

class MedicineApiException implements Exception {
  final String message;
  MedicineApiException(this.message);
  @override
  String toString() => message;
}
