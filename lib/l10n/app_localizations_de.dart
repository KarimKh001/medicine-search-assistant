// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Produktsuche';

  @override
  String get searchTabLabel => 'Suche';

  @override
  String get libraryTabLabel => 'Bibliothek';

  @override
  String get settingsTabLabel => 'Einstellungen';

  @override
  String get searchHint => 'Medikament suchen (z. B. Ibuprofen)';

  @override
  String get searchButton => 'Suchen';

  @override
  String get searchingLibrary => 'Bibliothek wird durchsucht...';

  @override
  String get searchingApi => 'Öffentliche API wird durchsucht...';

  @override
  String get noResults =>
      'Keine Ergebnisse gefunden. Versuchen Sie einen anderen Namen.';

  @override
  String get searchError =>
      'Bei der Suche ist ein Fehler aufgetreten. Bitte erneut versuchen.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get addManually => 'Manuell hinzufügen';

  @override
  String get addMedicineTitle => 'Neues Medikament hinzufügen';

  @override
  String get addMedicineSubtitle =>
      'In der öffentlichen API nicht gefunden? Fügen Sie es manuell hinzu.';

  @override
  String get nameFieldLabel => 'Medikamentenname';

  @override
  String get nameRequiredError => 'Bitte geben Sie einen Medikamentennamen ein';

  @override
  String get manufacturerFieldLabel => 'Hersteller (optional)';

  @override
  String get dosageFieldLabel => 'Darreichungsform (optional)';

  @override
  String get descriptionFieldLabel => 'Beschreibung (optional)';

  @override
  String get addButton => 'Hinzufügen';

  @override
  String get addedManually => 'Zu Ihrer Bibliothek hinzugefügt';

  @override
  String get photoFieldLabel => 'Foto (optional)';

  @override
  String get imageUrlFieldLabel => 'Bild-URL (optional)';

  @override
  String get imagePreviewHint => 'Vorschau der eingefügten URL';

  @override
  String get uploadTimedOut =>
      'Der Upload hat das Zeitlimit überschritten. Überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get findPhotoButton => 'Foto online suchen';

  @override
  String get searchPhotoOnGoogle => 'Foto bei Google suchen';

  @override
  String get googlePhotoSearchTitle => 'Foto finden';

  @override
  String get tapPhotoHint =>
      'Tippen Sie unten auf ein Foto und dann auf \"Foto übernehmen\"';

  @override
  String get grabPhotoButton => 'Foto übernehmen';

  @override
  String get photoAttached => 'Foto angehängt';

  @override
  String get photoGrabFailed =>
      'Dieses Foto konnte nicht angehängt werden. Bitte versuchen Sie ein anderes.';

  @override
  String get noPhotoSelectedYet =>
      'Tippen Sie zuerst auf ein Bild auf der Seite';

  @override
  String get openInBrowserFallback => 'Google Bilder im Browser öffnen';

  @override
  String get webViewUnavailableOnWeb =>
      'Die In-App-Vorschau ist im Web nicht verfügbar. Öffnen Sie Google Bilder in einem neuen Tab, kopieren Sie die Bildadresse und fügen Sie sie unten ein.';

  @override
  String get loadingWebPage => 'Wird geladen...';

  @override
  String get savedToLibraryTooltip => 'In Ihrer Bibliothek gespeichert';

  @override
  String get resultsFromApi => 'Ergebnisse der öffentlichen API';

  @override
  String get saveToLibrary => 'In Bibliothek speichern';

  @override
  String get alreadyInLibrary => 'Bereits in der Bibliothek';

  @override
  String get savedSuccessfully => 'Erfolgreich in Firebase gespeichert';

  @override
  String get saveFailed => 'Speichern fehlgeschlagen. Bitte erneut versuchen.';

  @override
  String get fetchingPhoto => 'Kein Foto in den API-Daten, Websuche läuft...';

  @override
  String get photoFoundOnWeb => 'Foto im Web gefunden und angehängt';

  @override
  String get noPhotoFound => 'Auch im Web konnte kein Foto gefunden werden';

  @override
  String get libraryTitle => 'Gespeicherte Medikamente';

  @override
  String get emptyLibrary =>
      'Ihre Bibliothek ist leer. Suchen und speichern Sie ein Medikament.';

  @override
  String get loadingLibrary => 'Gespeicherte Medikamente werden geladen...';

  @override
  String get deleteItem => 'Löschen';

  @override
  String get deleteConfirmTitle => 'Dieses Medikament löschen?';

  @override
  String get deleteConfirmBody => 'Es wird dauerhaft aus Firebase entfernt.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get deletedSuccessfully => 'Gelöscht';

  @override
  String get manufacturerLabel => 'Hersteller';

  @override
  String get dosageLabel => 'Darreichungsform';

  @override
  String get descriptionLabel => 'Beschreibung';

  @override
  String get sourceLabel => 'Quelle';

  @override
  String get sourceApi => 'Öffentliche API';

  @override
  String get sourceWeb => 'Web-Bildsuche';

  @override
  String get sourceManual => 'Manuell hinzugefügtes Foto';

  @override
  String get noDescriptionAvailable => 'Keine Beschreibung verfügbar';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get themeSection => 'Thema';

  @override
  String get lightMode => 'Hell';

  @override
  String get darkMode => 'Dunkel';

  @override
  String get systemMode => 'Systemeinstellung folgen';

  @override
  String get accentColor => 'Akzentfarbe';

  @override
  String get languageSection => 'Sprache';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageArabic => 'Arabisch';

  @override
  String get languageFrench => 'Französisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageTurkish => 'Türkisch';

  @override
  String get close => 'Schließen';

  @override
  String get ok => 'OK';

  @override
  String get filterSearchInLabel => 'Suchen in';

  @override
  String get filterAll => 'Alle Felder';

  @override
  String get filterBrandName => 'Markenname';

  @override
  String get filterGenericName => 'Generischer Name';

  @override
  String get filterIngredient => 'Wirkstoff';

  @override
  String get filterRouteLabel => 'Anwendungsweg';

  @override
  String get filterRouteAny => 'Alle Wege';

  @override
  String get sameIngredientTooltip =>
      'Andere Arzneimittel mit diesem Wirkstoff';

  @override
  String get sameIngredientScreenTitle => 'Gleicher Wirkstoff';

  @override
  String get sameIngredientSubtitlePrefix => 'Enthält Wirkstoff';
}
