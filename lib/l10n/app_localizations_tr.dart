// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Ürün Arama';

  @override
  String get searchTabLabel => 'Ara';

  @override
  String get libraryTabLabel => 'Kitaplık';

  @override
  String get settingsTabLabel => 'Ayarlar';

  @override
  String get searchHint => 'İlaç ara (ör. ibuprofen)';

  @override
  String get searchButton => 'Ara';

  @override
  String get searchingLibrary => 'Kütüphanenizde aranıyor...';

  @override
  String get searchingApi => 'Genel API aranıyor...';

  @override
  String get noResults => 'Sonuç bulunamadı. Başka bir isim deneyin.';

  @override
  String get searchError =>
      'Arama sırasında bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get addManually => 'Manuel ekle';

  @override
  String get addMedicineTitle => 'Yeni ilaç ekle';

  @override
  String get addMedicineSubtitle =>
      'Genel API\'de bulunamadı mı? Manuel olarak ekleyin.';

  @override
  String get nameFieldLabel => 'İlaç adı';

  @override
  String get nameRequiredError => 'Lütfen bir ilaç adı girin';

  @override
  String get manufacturerFieldLabel => 'Üretici (isteğe bağlı)';

  @override
  String get dosageFieldLabel => 'Dozaj formu (isteğe bağlı)';

  @override
  String get descriptionFieldLabel => 'Açıklama (isteğe bağlı)';

  @override
  String get addButton => 'Ekle';

  @override
  String get addedManually => 'Kitaplığınıza eklendi';

  @override
  String get photoFieldLabel => 'Fotoğraf (isteğe bağlı)';

  @override
  String get imageUrlFieldLabel => 'Görsel URL’si (isteğe bağlı)';

  @override
  String get imagePreviewHint => 'Yapıştırılan URL\'nin önizlemesi';

  @override
  String get uploadTimedOut =>
      'Yükleme zaman aşımına uğradı. Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get findPhotoButton => 'Çevrimiçi fotoğraf ara';

  @override
  String get searchPhotoOnGoogle => 'Google\'da fotoğraf ara';

  @override
  String get googlePhotoSearchTitle => 'Fotoğraf bul';

  @override
  String get tapPhotoHint =>
      'Aşağıdan bir fotoğrafa dokunun, ardından \"Fotoğrafı Al\"a dokunun';

  @override
  String get grabPhotoButton => 'Fotoğrafı Al';

  @override
  String get photoAttached => 'Fotoğraf eklendi';

  @override
  String get photoGrabFailed => 'Bu fotoğraf eklenemedi. Başka birini deneyin.';

  @override
  String get noPhotoSelectedYet => 'Önce sayfadaki bir görsele dokunun';

  @override
  String get openInBrowserFallback => 'Google Görseller\'i tarayıcıda aç';

  @override
  String get webViewUnavailableOnWeb =>
      'Uygulama içi önizleme web\'de kullanılamıyor. Google Görseller\'i yeni bir sekmede açın, görsel adresini kopyalayıp aşağıya yapıştırın.';

  @override
  String get loadingWebPage => 'Yükleniyor...';

  @override
  String get savedToLibraryTooltip => 'Kitaplığınıza kaydedildi';

  @override
  String get resultsFromApi => 'Genel API sonuçları';

  @override
  String get saveToLibrary => 'Kitaplığa kaydet';

  @override
  String get alreadyInLibrary => 'Zaten kitaplıkta';

  @override
  String get savedSuccessfully => 'Firebase\'e başarıyla kaydedildi';

  @override
  String get saveFailed => 'Kaydetme başarısız oldu. Lütfen tekrar deneyin.';

  @override
  String get fetchingPhoto => 'API verisinde fotoğraf yok, web\'de aranıyor...';

  @override
  String get photoFoundOnWeb => 'Web\'de fotoğraf bulundu ve eklendi';

  @override
  String get noPhotoFound => 'Web\'de de fotoğraf bulunamadı';

  @override
  String get libraryTitle => 'Kaydedilen İlaçlar';

  @override
  String get emptyLibrary => 'Kitaplığınız boş. Bir ilaç arayıp kaydedin.';

  @override
  String get loadingLibrary => 'Kaydedilen ilaçlar yükleniyor...';

  @override
  String get deleteItem => 'Sil';

  @override
  String get deleteConfirmTitle => 'Bu ilaç silinsin mi?';

  @override
  String get deleteConfirmBody =>
      'Firebase\'den kalıcı olarak kaldırılacaktır.';

  @override
  String get cancel => 'İptal';

  @override
  String get confirm => 'Onayla';

  @override
  String get deletedSuccessfully => 'Silindi';

  @override
  String get manufacturerLabel => 'Üretici';

  @override
  String get dosageLabel => 'Dozaj formu';

  @override
  String get descriptionLabel => 'Açıklama';

  @override
  String get sourceLabel => 'Kaynak';

  @override
  String get sourceApi => 'Genel API';

  @override
  String get sourceWeb => 'Web görsel araması';

  @override
  String get sourceManual => 'Manuel eklenen fotoğraf';

  @override
  String get noDescriptionAvailable => 'Açıklama mevcut değil';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get themeSection => 'Tema';

  @override
  String get lightMode => 'Açık';

  @override
  String get darkMode => 'Koyu';

  @override
  String get systemMode => 'Sistemi izle';

  @override
  String get accentColor => 'Vurgu rengi';

  @override
  String get languageSection => 'Dil';

  @override
  String get languageEnglish => 'İngilizce';

  @override
  String get languageArabic => 'Arapça';

  @override
  String get languageFrench => 'Fransızca';

  @override
  String get languageGerman => 'Almanca';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get close => 'Kapat';

  @override
  String get ok => 'Tamam';

  @override
  String get filterSearchInLabel => 'Şurada ara';

  @override
  String get filterAll => 'Tüm alanlar';

  @override
  String get filterBrandName => 'Marka adı';

  @override
  String get filterGenericName => 'Jenerik ad';

  @override
  String get filterIngredient => 'Etken madde';

  @override
  String get filterRouteLabel => 'Uygulama yolu';

  @override
  String get filterRouteAny => 'Tüm yollar';

  @override
  String get sameIngredientTooltip => 'Aynı etken maddeye sahip diğer ilaçlar';

  @override
  String get sameIngredientScreenTitle => 'Aynı etken madde';

  @override
  String get sameIngredientSubtitlePrefix => 'İçeren ilaçlar';
}
