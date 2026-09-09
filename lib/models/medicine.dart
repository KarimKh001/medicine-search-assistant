import 'package:cloud_firestore/cloud_firestore.dart';

/// Where the medicine's photo ultimately came from.
///
/// The app never fetches a photo automatically. A photo only ever gets
/// attached because the user did one of two things themselves:
///  - [web]: grabbed it from the in-app Google image search browser
///    (see `google_photo_search_screen.dart`).
///  - [manual]: typed/pasted a direct image URL by hand in the "Add
///    manually" dialog.
/// [api] is unused today (openFDA never returns photos) but kept for
/// forward compatibility. [none] means no photo has been attached yet.
enum ImageSource { api, web, manual, none }

/// Core data model for a single medicine.
///
/// This model intentionally stores the *content* (name, manufacturer,
/// description, dosage form, image) as raw data pulled from the public API
/// (and, when missing, the web image search). Per the task requirements,
/// only the UI labels/messages around this data are localized -- the
/// content itself is never translated.
class Medicine {
  final String? id; // Firestore document id (null until saved)
  final String name;
  final String manufacturer;
  final String dosageForm;
  final String description;
  final String? imageUrl;
  final ImageSource imageSource;
  final String apiSourceId; // id/slug from the public API, used for de-duping
  final DateTime? createdAt;

  /// The active ingredient (openFDA's `substance_name`), e.g. "IBUPROFEN".
  /// Empty when the API didn't return a harmonized substance for this
  /// record. Powers the "other medicines with this ingredient" lookup.
  final String substanceName;

  Medicine({
    this.id,
    required this.name,
    required this.manufacturer,
    required this.dosageForm,
    required this.description,
    required this.imageUrl,
    required this.imageSource,
    required this.apiSourceId,
    this.substanceName = '',
    this.createdAt,
  });

  Medicine copyWith({
    String? id,
    String? imageUrl,
    ImageSource? imageSource,
    DateTime? createdAt,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name,
      manufacturer: manufacturer,
      dosageForm: dosageForm,
      description: description,
      imageUrl: imageUrl ?? this.imageUrl,
      imageSource: imageSource ?? this.imageSource,
      apiSourceId: apiSourceId,
      substanceName: substanceName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'nameLower': name.toLowerCase(),
      'manufacturer': manufacturer,
      'dosageForm': dosageForm,
      'description': description,
      'imageUrl': imageUrl,
      'imageSource': imageSource.name,
      'apiSourceId': apiSourceId,
      'substanceName': substanceName,
      'substanceNameLower': substanceName.toLowerCase(),
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }

  factory Medicine.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Medicine(
      id: doc.id,
      name: data['name'] ?? '',
      manufacturer: data['manufacturer'] ?? '',
      dosageForm: data['dosageForm'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      imageSource: ImageSource.values.firstWhere(
        (e) => e.name == data['imageSource'],
        orElse: () => ImageSource.none,
      ),
      apiSourceId: data['apiSourceId'] ?? '',
      substanceName: data['substanceName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
