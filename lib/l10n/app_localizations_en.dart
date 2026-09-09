// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Products Search';

  @override
  String get searchTabLabel => 'Search';

  @override
  String get libraryTabLabel => 'Library';

  @override
  String get settingsTabLabel => 'Settings';

  @override
  String get searchHint => 'Search medicines (e.g. ibuprofen)';

  @override
  String get searchButton => 'Search';

  @override
  String get searchingLibrary => 'Searching your library...';

  @override
  String get searchingApi => 'Searching public API...';

  @override
  String get noResults => 'No results found. Try another name.';

  @override
  String get searchError =>
      'Something went wrong while searching. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get addManually => 'Add manually';

  @override
  String get addMedicineTitle => 'Add a new medicine';

  @override
  String get addMedicineSubtitle =>
      'Couldn\'t find it in the public API? Add it by hand instead.';

  @override
  String get nameFieldLabel => 'Medicine name';

  @override
  String get nameRequiredError => 'Please enter a medicine name';

  @override
  String get manufacturerFieldLabel => 'Manufacturer (optional)';

  @override
  String get dosageFieldLabel => 'Dosage form (optional)';

  @override
  String get descriptionFieldLabel => 'Description (optional)';

  @override
  String get addButton => 'Add';

  @override
  String get addedManually => 'Added to your library';

  @override
  String get photoFieldLabel => 'Photo (optional)';

  @override
  String get imageUrlFieldLabel => 'Image URL (optional)';

  @override
  String get imagePreviewHint => 'This is a preview of the pasted URL';

  @override
  String get uploadTimedOut =>
      'Upload timed out. Check your connection and try again.';

  @override
  String get findPhotoButton => 'Find photo online';

  @override
  String get searchPhotoOnGoogle => 'Search photo on Google';

  @override
  String get googlePhotoSearchTitle => 'Find a photo';

  @override
  String get tapPhotoHint => 'Tap a photo below, then tap \"Grab Photo\"';

  @override
  String get grabPhotoButton => 'Grab Photo';

  @override
  String get photoAttached => 'Photo attached';

  @override
  String get photoGrabFailed =>
      'Couldn\'t attach that photo. Please try another one.';

  @override
  String get noPhotoSelectedYet => 'Tap an image in the page first';

  @override
  String get openInBrowserFallback => 'Open Google Images in browser';

  @override
  String get webViewUnavailableOnWeb =>
      'In-app preview isn\'t available on web. Open Google Images in a new tab, then copy the image address and paste it below.';

  @override
  String get loadingWebPage => 'Loading...';

  @override
  String get savedToLibraryTooltip => 'Saved to your library';

  @override
  String get resultsFromApi => 'Results from public API';

  @override
  String get saveToLibrary => 'Save to library';

  @override
  String get alreadyInLibrary => 'Already in library';

  @override
  String get savedSuccessfully => 'Saved to Firebase successfully';

  @override
  String get saveFailed => 'Failed to save. Please try again.';

  @override
  String get fetchingPhoto =>
      'No photo in API data, searching the web for one...';

  @override
  String get photoFoundOnWeb => 'Photo found on the web and attached';

  @override
  String get noPhotoFound => 'No photo could be found on the web either';

  @override
  String get libraryTitle => 'Saved Medicines';

  @override
  String get emptyLibrary =>
      'Your library is empty. Search and save a medicine to see it here.';

  @override
  String get loadingLibrary => 'Loading your saved medicines...';

  @override
  String get deleteItem => 'Delete';

  @override
  String get deleteConfirmTitle => 'Delete this medicine?';

  @override
  String get deleteConfirmBody =>
      'This will remove it from Firebase permanently.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get deletedSuccessfully => 'Deleted';

  @override
  String get manufacturerLabel => 'Manufacturer';

  @override
  String get dosageLabel => 'Dosage form';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get sourceLabel => 'Source';

  @override
  String get sourceApi => 'Public API';

  @override
  String get sourceWeb => 'Web image search';

  @override
  String get sourceManual => 'Manually added photo';

  @override
  String get noDescriptionAvailable => 'No description available';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get themeSection => 'Theme';

  @override
  String get lightMode => 'Light';

  @override
  String get darkMode => 'Dark';

  @override
  String get systemMode => 'Follow system';

  @override
  String get accentColor => 'Accent color';

  @override
  String get languageSection => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageFrench => 'French';

  @override
  String get languageGerman => 'German';

  @override
  String get languageTurkish => 'Turkish';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get filterSearchInLabel => 'Search in';

  @override
  String get filterAll => 'All fields';

  @override
  String get filterBrandName => 'Brand name';

  @override
  String get filterGenericName => 'Generic name';

  @override
  String get filterIngredient => 'Ingredient';

  @override
  String get filterRouteLabel => 'Route';

  @override
  String get filterRouteAny => 'Any route';

  @override
  String get sameIngredientTooltip => 'Other medicines with this ingredient';

  @override
  String get sameIngredientScreenTitle => 'Same ingredient';

  @override
  String get sameIngredientSubtitlePrefix => 'Medicines containing';
}
