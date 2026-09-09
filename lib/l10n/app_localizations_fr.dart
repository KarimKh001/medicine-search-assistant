// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Recherche de produits';

  @override
  String get searchTabLabel => 'Recherche';

  @override
  String get libraryTabLabel => 'Bibliothèque';

  @override
  String get settingsTabLabel => 'Paramètres';

  @override
  String get searchHint => 'Rechercher un médicament (ex. ibuprofène)';

  @override
  String get searchButton => 'Rechercher';

  @override
  String get searchingLibrary => 'Recherche dans votre bibliothèque...';

  @override
  String get searchingApi => 'Recherche dans l\'API publique...';

  @override
  String get noResults => 'Aucun résultat. Essayez un autre nom.';

  @override
  String get searchError =>
      'Une erreur est survenue lors de la recherche. Réessayez.';

  @override
  String get retry => 'Réessayer';

  @override
  String get addManually => 'Ajouter manuellement';

  @override
  String get addMedicineTitle => 'Ajouter un nouveau médicament';

  @override
  String get addMedicineSubtitle =>
      'Introuvable dans l\'API publique ? Ajoutez-le manuellement.';

  @override
  String get nameFieldLabel => 'Nom du médicament';

  @override
  String get nameRequiredError => 'Veuillez saisir un nom de médicament';

  @override
  String get manufacturerFieldLabel => 'Fabricant (optionnel)';

  @override
  String get dosageFieldLabel => 'Forme galénique (optionnel)';

  @override
  String get descriptionFieldLabel => 'Description (optionnel)';

  @override
  String get addButton => 'Ajouter';

  @override
  String get addedManually => 'Ajouté à votre bibliothèque';

  @override
  String get photoFieldLabel => 'Photo (optionnel)';

  @override
  String get imageUrlFieldLabel => 'URL de l\'image (optionnel)';

  @override
  String get imagePreviewHint => 'Aperçu de l\'URL collée';

  @override
  String get uploadTimedOut =>
      'Le téléchargement a expiré. Vérifiez votre connexion et réessayez.';

  @override
  String get findPhotoButton => 'Rechercher une photo en ligne';

  @override
  String get searchPhotoOnGoogle => 'Rechercher une photo sur Google';

  @override
  String get googlePhotoSearchTitle => 'Trouver une photo';

  @override
  String get tapPhotoHint =>
      'Appuyez sur une photo ci-dessous, puis sur « Récupérer la photo »';

  @override
  String get grabPhotoButton => 'Récupérer la photo';

  @override
  String get photoAttached => 'Photo ajoutée';

  @override
  String get photoGrabFailed =>
      'Impossible d\'ajouter cette photo. Essayez-en une autre.';

  @override
  String get noPhotoSelectedYet =>
      'Appuyez d\'abord sur une image dans la page';

  @override
  String get openInBrowserFallback => 'Ouvrir Google Images dans le navigateur';

  @override
  String get webViewUnavailableOnWeb =>
      'L\'aperçu intégré n\'est pas disponible sur le web. Ouvrez Google Images dans un nouvel onglet, copiez l\'adresse de l\'image, puis collez-la ci-dessous.';

  @override
  String get loadingWebPage => 'Chargement...';

  @override
  String get savedToLibraryTooltip => 'Enregistré dans votre bibliothèque';

  @override
  String get resultsFromApi => 'Résultats de l\'API publique';

  @override
  String get saveToLibrary => 'Enregistrer dans la bibliothèque';

  @override
  String get alreadyInLibrary => 'Déjà dans la bibliothèque';

  @override
  String get savedSuccessfully => 'Enregistré dans Firebase avec succès';

  @override
  String get saveFailed => 'Échec de l\'enregistrement. Réessayez.';

  @override
  String get fetchingPhoto =>
      'Aucune photo dans l\'API, recherche sur le web en cours...';

  @override
  String get photoFoundOnWeb => 'Photo trouvée sur le web et ajoutée';

  @override
  String get noPhotoFound => 'Aucune photo trouvée sur le web non plus';

  @override
  String get libraryTitle => 'Médicaments enregistrés';

  @override
  String get emptyLibrary =>
      'Votre bibliothèque est vide. Recherchez et enregistrez un médicament.';

  @override
  String get loadingLibrary => 'Chargement de vos médicaments enregistrés...';

  @override
  String get deleteItem => 'Supprimer';

  @override
  String get deleteConfirmTitle => 'Supprimer ce médicament ?';

  @override
  String get deleteConfirmBody =>
      'Il sera définitivement supprimé de Firebase.';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get deletedSuccessfully => 'Supprimé';

  @override
  String get manufacturerLabel => 'Fabricant';

  @override
  String get dosageLabel => 'Forme galénique';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get sourceLabel => 'Source';

  @override
  String get sourceApi => 'API publique';

  @override
  String get sourceWeb => 'Recherche d\'image web';

  @override
  String get sourceManual => 'Photo ajoutée manuellement';

  @override
  String get noDescriptionAvailable => 'Aucune description disponible';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get themeSection => 'Thème';

  @override
  String get lightMode => 'Clair';

  @override
  String get darkMode => 'Sombre';

  @override
  String get systemMode => 'Suivre le système';

  @override
  String get accentColor => 'Couleur d\'accent';

  @override
  String get languageSection => 'Langue';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageArabic => 'Arabe';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageGerman => 'Allemand';

  @override
  String get languageTurkish => 'Turc';

  @override
  String get close => 'Fermer';

  @override
  String get ok => 'OK';

  @override
  String get filterSearchInLabel => 'Rechercher dans';

  @override
  String get filterAll => 'Tous les champs';

  @override
  String get filterBrandName => 'Nom de marque';

  @override
  String get filterGenericName => 'Nom générique';

  @override
  String get filterIngredient => 'Ingrédient';

  @override
  String get filterRouteLabel => 'Voie d\'administration';

  @override
  String get filterRouteAny => 'Toutes voies';

  @override
  String get sameIngredientTooltip => 'Autres médicaments avec cet ingrédient';

  @override
  String get sameIngredientScreenTitle => 'Même ingrédient';

  @override
  String get sameIngredientSubtitlePrefix => 'Médicaments contenant';
}
