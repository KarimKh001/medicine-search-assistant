// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'بحث المنتجات';

  @override
  String get searchTabLabel => 'بحث';

  @override
  String get libraryTabLabel => 'المكتبة';

  @override
  String get settingsTabLabel => 'الإعدادات';

  @override
  String get searchHint => 'ابحث عن دواء (مثال: ايبوبروفين)';

  @override
  String get searchButton => 'بحث';

  @override
  String get searchingLibrary => 'جارٍ البحث في مكتبتك...';

  @override
  String get searchingApi => 'جارٍ البحث في واجهة البرمجة العامة...';

  @override
  String get noResults => 'لا توجد نتائج. جرّب اسمًا آخر.';

  @override
  String get searchError => 'حدث خطأ أثناء البحث. حاول مرة أخرى.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get addManually => 'إضافة يدويًا';

  @override
  String get addMedicineTitle => 'إضافة دواء جديد';

  @override
  String get addMedicineSubtitle =>
      'لم تجده في واجهة البرمجة العامة؟ أضفه يدويًا بدلاً من ذلك.';

  @override
  String get nameFieldLabel => 'اسم الدواء';

  @override
  String get nameRequiredError => 'الرجاء إدخال اسم الدواء';

  @override
  String get manufacturerFieldLabel => 'الشركة المصنعة (اختياري)';

  @override
  String get dosageFieldLabel => 'شكل الجرعة (اختياري)';

  @override
  String get descriptionFieldLabel => 'الوصف (اختياري)';

  @override
  String get addButton => 'إضافة';

  @override
  String get addedManually => 'تمت الإضافة إلى مكتبتك';

  @override
  String get photoFieldLabel => 'الصورة (اختياري)';

  @override
  String get imageUrlFieldLabel => 'رابط الصورة (اختياري)';

  @override
  String get imagePreviewHint => 'هذه معاينة للرابط الذي أدخلته';

  @override
  String get uploadTimedOut =>
      'انتهت مهلة الرفع. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get findPhotoButton => 'البحث عن صورة عبر الإنترنت';

  @override
  String get searchPhotoOnGoogle => 'البحث عن صورة في Google';

  @override
  String get googlePhotoSearchTitle => 'العثور على صورة';

  @override
  String get tapPhotoHint =>
      'اضغط على إحدى الصور أدناه، ثم اضغط على \"التقاط الصورة\"';

  @override
  String get grabPhotoButton => 'التقاط الصورة';

  @override
  String get photoAttached => 'تم إرفاق الصورة';

  @override
  String get photoGrabFailed => 'تعذر إرفاق هذه الصورة. جرّب صورة أخرى.';

  @override
  String get noPhotoSelectedYet => 'اضغط على صورة في الصفحة أولاً';

  @override
  String get openInBrowserFallback => 'افتح صور Google في المتصفح';

  @override
  String get webViewUnavailableOnWeb =>
      'المعاينة داخل التطبيق غير متاحة على الويب. افتح صور Google في علامة تبويب جديدة، ثم انسخ رابط الصورة والصقه أدناه.';

  @override
  String get loadingWebPage => 'جارٍ التحميل...';

  @override
  String get savedToLibraryTooltip => 'تم الحفظ في مكتبتك';

  @override
  String get resultsFromApi => 'نتائج من واجهة البرمجة العامة';

  @override
  String get saveToLibrary => 'حفظ في المكتبة';

  @override
  String get alreadyInLibrary => 'موجود بالفعل في المكتبة';

  @override
  String get savedSuccessfully => 'تم الحفظ في Firebase بنجاح';

  @override
  String get saveFailed => 'فشل الحفظ. حاول مرة أخرى.';

  @override
  String get fetchingPhoto =>
      'لا توجد صورة في بيانات الواجهة، جارٍ البحث عنها في الويب...';

  @override
  String get photoFoundOnWeb => 'تم العثور على صورة من الويب وإرفاقها';

  @override
  String get noPhotoFound => 'تعذر العثور على صورة في الويب أيضًا';

  @override
  String get libraryTitle => 'الأدوية المحفوظة';

  @override
  String get emptyLibrary => 'مكتبتك فارغة. ابحث واحفظ دواءً ليظهر هنا.';

  @override
  String get loadingLibrary => 'جارٍ تحميل الأدوية المحفوظة...';

  @override
  String get deleteItem => 'حذف';

  @override
  String get deleteConfirmTitle => 'حذف هذا الدواء؟';

  @override
  String get deleteConfirmBody => 'سيتم حذفه نهائيًا من Firebase.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get deletedSuccessfully => 'تم الحذف';

  @override
  String get manufacturerLabel => 'الشركة المصنعة';

  @override
  String get dosageLabel => 'شكل الجرعة';

  @override
  String get descriptionLabel => 'الوصف';

  @override
  String get sourceLabel => 'المصدر';

  @override
  String get sourceApi => 'واجهة برمجة عامة';

  @override
  String get sourceWeb => 'بحث صور الويب';

  @override
  String get sourceManual => 'صورة أُضيفت يدويًا';

  @override
  String get noDescriptionAvailable => 'لا يوجد وصف متاح';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get themeSection => 'المظهر';

  @override
  String get lightMode => 'فاتح';

  @override
  String get darkMode => 'داكن';

  @override
  String get systemMode => 'حسب النظام';

  @override
  String get accentColor => 'اللون الرئيسي';

  @override
  String get languageSection => 'اللغة';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageFrench => 'الفرنسية';

  @override
  String get languageGerman => 'الألمانية';

  @override
  String get languageTurkish => 'التركية';

  @override
  String get close => 'إغلاق';

  @override
  String get ok => 'موافق';

  @override
  String get filterSearchInLabel => 'بحث في';

  @override
  String get filterAll => 'كل الحقول';

  @override
  String get filterBrandName => 'الاسم التجاري';

  @override
  String get filterGenericName => 'الاسم العلمي';

  @override
  String get filterIngredient => 'المادة الفعالة';

  @override
  String get filterRouteLabel => 'طريقة الاستخدام';

  @override
  String get filterRouteAny => 'أي طريقة';

  @override
  String get sameIngredientTooltip => 'أدوية أخرى تحتوي على نفس المادة الفعالة';

  @override
  String get sameIngredientScreenTitle => 'نفس المادة الفعالة';

  @override
  String get sameIngredientSubtitlePrefix => 'أدوية تحتوي على';
}
