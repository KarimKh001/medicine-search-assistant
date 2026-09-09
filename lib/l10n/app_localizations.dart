import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('tr')
  ];

  /// App bar title / app name
  ///
  /// In en, this message translates to:
  /// **'Products Search'**
  String get appTitle;

  /// No description provided for @searchTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTabLabel;

  /// No description provided for @libraryTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTabLabel;

  /// No description provided for @settingsTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTabLabel;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search medicines (e.g. ibuprofen)'**
  String get searchHint;

  /// No description provided for @searchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchButton;

  /// No description provided for @searchingLibrary.
  ///
  /// In en, this message translates to:
  /// **'Searching your library...'**
  String get searchingLibrary;

  /// No description provided for @searchingApi.
  ///
  /// In en, this message translates to:
  /// **'Searching public API...'**
  String get searchingApi;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found. Try another name.'**
  String get noResults;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while searching. Please try again.'**
  String get searchError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get addManually;

  /// No description provided for @addMedicineTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new medicine'**
  String get addMedicineTitle;

  /// No description provided for @addMedicineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find it in the public API? Add it by hand instead.'**
  String get addMedicineSubtitle;

  /// No description provided for @nameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicine name'**
  String get nameFieldLabel;

  /// No description provided for @nameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a medicine name'**
  String get nameRequiredError;

  /// No description provided for @manufacturerFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer (optional)'**
  String get manufacturerFieldLabel;

  /// No description provided for @dosageFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Dosage form (optional)'**
  String get dosageFieldLabel;

  /// No description provided for @descriptionFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionFieldLabel;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @addedManually.
  ///
  /// In en, this message translates to:
  /// **'Added to your library'**
  String get addedManually;

  /// No description provided for @photoFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Photo (optional)'**
  String get photoFieldLabel;

  /// No description provided for @imageUrlFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Image URL (optional)'**
  String get imageUrlFieldLabel;

  /// No description provided for @imagePreviewHint.
  ///
  /// In en, this message translates to:
  /// **'This is a preview of the pasted URL'**
  String get imagePreviewHint;

  /// No description provided for @uploadTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Upload timed out. Check your connection and try again.'**
  String get uploadTimedOut;

  /// No description provided for @findPhotoButton.
  ///
  /// In en, this message translates to:
  /// **'Find photo online'**
  String get findPhotoButton;

  /// No description provided for @searchPhotoOnGoogle.
  ///
  /// In en, this message translates to:
  /// **'Search photo on Google'**
  String get searchPhotoOnGoogle;

  /// No description provided for @googlePhotoSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a photo'**
  String get googlePhotoSearchTitle;

  /// No description provided for @tapPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a photo below, then tap \"Grab Photo\"'**
  String get tapPhotoHint;

  /// No description provided for @grabPhotoButton.
  ///
  /// In en, this message translates to:
  /// **'Grab Photo'**
  String get grabPhotoButton;

  /// No description provided for @photoAttached.
  ///
  /// In en, this message translates to:
  /// **'Photo attached'**
  String get photoAttached;

  /// No description provided for @photoGrabFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t attach that photo. Please try another one.'**
  String get photoGrabFailed;

  /// No description provided for @noPhotoSelectedYet.
  ///
  /// In en, this message translates to:
  /// **'Tap an image in the page first'**
  String get noPhotoSelectedYet;

  /// No description provided for @openInBrowserFallback.
  ///
  /// In en, this message translates to:
  /// **'Open Google Images in browser'**
  String get openInBrowserFallback;

  /// No description provided for @webViewUnavailableOnWeb.
  ///
  /// In en, this message translates to:
  /// **'In-app preview isn\'t available on web. Open Google Images in a new tab, then copy the image address and paste it below.'**
  String get webViewUnavailableOnWeb;

  /// No description provided for @loadingWebPage.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingWebPage;

  /// No description provided for @savedToLibraryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Saved to your library'**
  String get savedToLibraryTooltip;

  /// No description provided for @resultsFromApi.
  ///
  /// In en, this message translates to:
  /// **'Results from public API'**
  String get resultsFromApi;

  /// No description provided for @saveToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Save to library'**
  String get saveToLibrary;

  /// No description provided for @alreadyInLibrary.
  ///
  /// In en, this message translates to:
  /// **'Already in library'**
  String get alreadyInLibrary;

  /// No description provided for @savedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Saved to Firebase successfully'**
  String get savedSuccessfully;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save. Please try again.'**
  String get saveFailed;

  /// No description provided for @fetchingPhoto.
  ///
  /// In en, this message translates to:
  /// **'No photo in API data, searching the web for one...'**
  String get fetchingPhoto;

  /// No description provided for @photoFoundOnWeb.
  ///
  /// In en, this message translates to:
  /// **'Photo found on the web and attached'**
  String get photoFoundOnWeb;

  /// No description provided for @noPhotoFound.
  ///
  /// In en, this message translates to:
  /// **'No photo could be found on the web either'**
  String get noPhotoFound;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Medicines'**
  String get libraryTitle;

  /// No description provided for @emptyLibrary.
  ///
  /// In en, this message translates to:
  /// **'Your library is empty. Search and save a medicine to see it here.'**
  String get emptyLibrary;

  /// No description provided for @loadingLibrary.
  ///
  /// In en, this message translates to:
  /// **'Loading your saved medicines...'**
  String get loadingLibrary;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteItem;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this medicine?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will remove it from Firebase permanently.'**
  String get deleteConfirmBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @deletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deletedSuccessfully;

  /// No description provided for @manufacturerLabel.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get manufacturerLabel;

  /// No description provided for @dosageLabel.
  ///
  /// In en, this message translates to:
  /// **'Dosage form'**
  String get dosageLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @sourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get sourceLabel;

  /// No description provided for @sourceApi.
  ///
  /// In en, this message translates to:
  /// **'Public API'**
  String get sourceApi;

  /// No description provided for @sourceWeb.
  ///
  /// In en, this message translates to:
  /// **'Web image search'**
  String get sourceWeb;

  /// No description provided for @sourceManual.
  ///
  /// In en, this message translates to:
  /// **'Manually added photo'**
  String get sourceManual;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No description available'**
  String get noDescriptionAvailable;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @themeSection.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSection;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkMode;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get systemMode;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get accentColor;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageGerman;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get languageTurkish;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @filterSearchInLabel.
  ///
  /// In en, this message translates to:
  /// **'Search in'**
  String get filterSearchInLabel;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All fields'**
  String get filterAll;

  /// No description provided for @filterBrandName.
  ///
  /// In en, this message translates to:
  /// **'Brand name'**
  String get filterBrandName;

  /// No description provided for @filterGenericName.
  ///
  /// In en, this message translates to:
  /// **'Generic name'**
  String get filterGenericName;

  /// No description provided for @filterIngredient.
  ///
  /// In en, this message translates to:
  /// **'Ingredient'**
  String get filterIngredient;

  /// No description provided for @filterRouteLabel.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get filterRouteLabel;

  /// No description provided for @filterRouteAny.
  ///
  /// In en, this message translates to:
  /// **'Any route'**
  String get filterRouteAny;

  /// No description provided for @sameIngredientTooltip.
  ///
  /// In en, this message translates to:
  /// **'Other medicines with this ingredient'**
  String get sameIngredientTooltip;

  /// No description provided for @sameIngredientScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Same ingredient'**
  String get sameIngredientScreenTitle;

  /// No description provided for @sameIngredientSubtitlePrefix.
  ///
  /// In en, this message translates to:
  /// **'Medicines containing'**
  String get sameIngredientSubtitlePrefix;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en', 'fr', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
