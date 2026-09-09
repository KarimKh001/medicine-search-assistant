# medicine_search_assistant

## 1. Overview

This project is a Flutter application developed as an internship prototype/demo before moving on to more advanced functionality in the main application.

The demo focuses on a medicine-search and library workflow:

- Search medicines using the public **openFDA Drug Label API**
- Search the local Firestore-backed medicine library first
- Merge local and API results while avoiding duplicate medicine names
- Automatically cache newly discovered API medicines in Firestore
- Manually add medicines when the public API does not provide a useful result
- Let the user explicitly choose a medicine image through a Google Images search flow
- Browse medicines already saved in the library
- Find other medicines sharing the same active ingredient
- Delete medicines from the library
- Switch between light, dark, and system themes
- Change the application's accent color
- Switch the UI between English, Arabic, French, German, and Turkish
- Persist theme and language preferences between app launches

> **Important:** This repository represents a technical demo/prototype. The medicine data is informational and comes from external/public sources; the application is not intended to provide medical advice.

---

## 2. Technology Stack

### Frontend

- **Flutter**
- **Dart**
- Material 3 UI

### Backend / Persistence

- **Firebase Core** for Firebase initialization
- **Cloud Firestore** for the medicine library

### External API

- **openFDA Drug Label API**
- Endpoint used by the project:
  - `https://api.fda.gov/drug/label.json`

### State / Local Preferences

- **Provider** for theme and locale state management
- **SharedPreferences** for persisting theme and language settings

### Networking / Media

- `http` for openFDA API requests
- `cached_network_image` for displaying remote medicine images
- `webview_flutter` for the in-app Google Images experience on supported platforms
- `url_launcher` for opening the Google Images search externally when required

### Localization

Flutter's generated localization system using:

- `.arb` translation files
- `AppLocalizations`
- Flutter localization delegates

Supported UI languages:

- English (`en`)
- Arabic (`ar`)
- French (`fr`)
- German (`de`)
- Turkish (`tr`)

---

## 3. Project Structure

```text
lib/
├── main.dart
├── firebase_options.dart
│
├── models/
│   └── medicine.dart
│
├── providers/
│   ├── locale_provider.dart
│   └── theme_provider.dart
│
├── screens/
│   ├── add_medicine_dialog.dart
│   ├── google_photo_search_screen.dart
│   ├── home_screen.dart
│   ├── ingredient_results_screen.dart
│   ├── library_screen.dart
│   ├── search_screen.dart
│   └── settings_screen.dart
│
├── services/
│   ├── firebase_service.dart
│   └── medicine_api_service.dart
│
├── widgets/
│   └── medicine_card.dart
│
└── l10n/
    ├── app_en.arb
    ├── app_ar.arb
    ├── app_fr.arb
    ├── app_de.arb
    ├── app_tr.arb
    └── generated localization files
```

The project follows a lightweight separation of concerns:

- **Models** represent application data.
- **Services** contain API and database logic.
- **Screens** contain page-level UI and user interaction.
- **Widgets** contain reusable UI components.
- **Providers** manage application-wide preferences/state.
- **Localization files** contain translated UI strings.

---

# 4. Application Architecture

At a high level, the application can be viewed as:

```text
                    ┌──────────────────────┐
                    │      Flutter UI      │
                    │                      │
                    │ Search / Library /   │
                    │ Settings / Dialogs   │
                    └──────────┬───────────┘
                               │
                 ┌─────────────┴─────────────┐
                 │                           │
                 ▼                           ▼
        ┌─────────────────┐         ┌─────────────────┐
        │ Firebase Service│         │ Medicine API    │
        │                 │         │ Service         │
        │ Firestore CRUD  │         │                 │
        │ Search / Cache  │         │ openFDA client  │
        └────────┬────────┘         └────────┬────────┘
                 │                           │
                 ▼                           ▼
          ┌────────────┐              ┌─────────────┐
          │ Firestore  │              │   openFDA   │
          │ medicines  │              │ Public API  │
          └────────────┘              └─────────────┘

                         ┌─────────────────┐
                         │ Google Images   │
                         │ user-selected   │
                         │ image URL       │
                         └─────────────────┘
```

The UI does not directly communicate with Firestore or openFDA. Instead, those responsibilities are centralized in service classes.

---

# 5. Application Entry Point

## `main.dart`

The application starts by:

1. Ensuring Flutter bindings are initialized.
2. Initializing Firebase.
3. Creating the `ThemeProvider`.
4. Creating the `LocaleProvider`.
5. Loading persisted preferences using `SharedPreferences`.
6. Starting the Flutter application.
7. Registering the providers with `MultiProvider`.
8. Configuring Material 3, localization, theme mode, and supported locales.

Conceptually:

```text
main()
  │
  ├── Firebase.initializeApp()
  │
  ├── ThemeProvider.load()
  │
  ├── LocaleProvider.load()
  │
  └── runApp()
          │
          └── ProductsSearchApp
                  │
                  ├── ThemeProvider
                  └── LocaleProvider
```

---

# 6. Navigation Structure

`HomeShell` provides the main application shell.

It contains three primary sections:

```text
HomeShell
│
├── Search
│   └── SearchScreen
│
├── Library
│   └── LibraryScreen
│
└── Settings
    └── SettingsScreen
```

An `IndexedStack` is used for the three screens. This allows the application to preserve each tab's widget state while switching between sections.

---

# 7. Medicine Data Model

## `models/medicine.dart`

The central domain object is the `Medicine` class.

Main fields:

| Field | Purpose |
|---|---|
| `id` | Firestore document ID |
| `name` | Display/search name of the medicine |
| `manufacturer` | Manufacturer information |
| `dosageForm` | Route/dosage-related information |
| `description` | Short description or usage information |
| `imageUrl` | Optional remote image URL |
| `imageSource` | Tracks where the image came from |
| `apiSourceId` | Identifier from the external API |
| `substanceName` | Active ingredient |
| `createdAt` | Creation time in Firestore |

The model also provides:

- `copyWith()` for immutable-style updates
- `toFirestore()` for persistence
- `fromFirestore()` for converting Firestore documents back into Dart objects

---

# 8. Image Source Tracking

The model defines:

```dart
enum ImageSource {
  api,
  web,
  manual,
  none,
}
```

This is useful because the image is not treated as an anonymous URL.

The application knows whether the image was:

- obtained from a web search selected by the user
- entered manually
- supplied by an API in a future implementation
- not available

The current openFDA endpoint does not provide medicine photos, so newly imported API records normally start with `ImageSource.none`.

---

# 9. Firestore Data Structure

Medicines are stored in the Firestore collection:

```text
medicines/
```

A document approximately follows this structure:

```json
{
  "name": "Example Medicine",
  "nameLower": "example medicine",
  "manufacturer": "Example Manufacturer",
  "dosageForm": "ORAL",
  "description": "Medicine description...",
  "imageUrl": "https://...",
  "imageSource": "web",
  "apiSourceId": "external-id",
  "substanceName": "IBUPROFEN",
  "substanceNameLower": "ibuprofen",
  "createdAt": "Firestore Timestamp"
}
```

### Why store lowercase fields?

The project stores:

```text
nameLower
substanceNameLower
```

in addition to the display values.

This provides normalized values that can be used for case-insensitive equality checks and future query optimization.

---

# 10. Medicine API Service

## `services/medicine_api_service.dart`

`MedicineApiService` is a thin wrapper around openFDA.

Its main responsibility is:

```text
Flutter
   │
   ▼
MedicineApiService
   │
   ▼
HTTP GET
   │
   ▼
openFDA
   │
   ▼
JSON
   │
   ▼
Medicine objects
```

The service keeps API-specific implementation details out of the UI.

---

# 11. openFDA Search Logic

The application supports four search scopes:

```dart
enum SearchField {
  all,
  brand,
  generic,
  ingredient,
}
```

They map to openFDA fields as follows:

| App filter | openFDA field |
|---|---|
| All | `brand_name`, `generic_name`, `substance_name` |
| Brand | `brand_name` |
| Generic | `generic_name` |
| Ingredient | `substance_name` |

For example, an "all" search constructs a query conceptually equivalent to:

```text
openfda.brand_name:"query"
OR openfda.generic_name:"query"
OR openfda.substance_name:"query"
```

An optional route filter can then be added using:

```text
AND openfda.route:"ORAL"
```

The query is passed through Dart's `Uri.https(...)` rather than manually constructing a URL. This ensures query parameters are correctly encoded.

---

# 12. API Response Mapping

openFDA responses are JSON records, while the rest of the application works with `Medicine` objects.

The API service maps fields approximately like this:

```text
openFDA response
       │
       ├── brand_name       ──┐
       ├── generic_name     ──┤
       ├── manufacturer_name ─┤
       ├── route             ├──> Medicine
       ├── substance_name    ─┤
       ├── description       ─┤
       └── id                ──┘
```

The preferred display name is the brand name when available; otherwise the generic name is used.

Descriptions are selected from available fields such as:

1. `description`
2. `indications_and_usage`
3. `purpose`

The resulting description is truncated to keep the UI cards compact.

---

# 13. Main Search Flow

One of the main design decisions in the prototype is the **Firestore-first, API-always** search strategy.

The flow is:

```text
User enters query
        │
        ▼
SearchScreen
        │
        ▼
FirebaseMedicineService.searchAndCache()
        │
        ├───────────────► Firestore library search
        │
        ▼
   cached results
        │
        ▼
   openFDA search
        │
        ▼
   API results
        │
        ▼
 Merge + de-duplicate
        │
        ▼
 Persist missing API results
        │
        ▼
 Return combined results
        │
        ▼
     SearchScreen
```

### Why not return immediately when Firestore has results?

A cached result does not necessarily mean the cache is complete.

For example:

```text
Previous search:
"Advil"
    ↓
Advil saved to Firestore

Later search:
"ibuprofen"
    ↓
Firestore finds Advil
```

If the application stopped after finding that cached result, it could incorrectly hide other ibuprofen-related medicines that exist in openFDA but were never previously cached.

Therefore:

> **Firestore results are returned as part of the search, but the public API is still queried.**

---

# 14. Result Merging and De-duplication

Results are merged using the medicine name as a case-insensitive key.

Conceptually:

```dart
Map<String, Medicine> byName
```

where the key is:

```dart
medicine.name.toLowerCase()
```

The merge process is:

1. Add cached Firestore results.
2. Iterate through API results.
3. Check whether the normalized name already exists.
4. If it exists, keep the cached record.
5. If it does not exist, check Firestore again for an exact existing document.
6. If still missing, save the API result to Firestore.
7. Add the saved result to the final result map.

This has an important advantage:

**A cached medicine keeps its Firestore ID and any previously attached photo instead of being replaced by a fresh API object.**

---

# 15. Search Filters

The search screen supports two filtering dimensions.

## Search field

Users can search in:

- All
- Brand name
- Generic name
- Ingredient

## Route

The user can additionally select an administration route such as:

- ORAL
- TOPICAL
- INTRAVENOUS
- INTRAMUSCULAR
- SUBCUTANEOUS
- OPHTHALMIC
- NASAL
- RECTAL
- VAGINAL
- TRANSDERMAL
- SUBLINGUAL
- INHALATION
- DENTAL
- OTIC

The route is based on the `openFDA.route` field.

---

# 16. Manual Medicine Entry

## `screens/add_medicine_dialog.dart`

If a search produces no useful result, the user can choose:

```text
Add manually
```

The dialog collects:

- Medicine name
- Manufacturer
- Dosage form
- Description
- Optional image URL

The name is required.

The medicine is then passed to:

```dart
FirebaseMedicineService.saveIfNew()
```

---

# 17. Manual Save Logic

The manual save flow is:

```text
User fills form
      │
      ▼
Validate required fields
      │
      ▼
Normalize image URL
      │
      ▼
Create Medicine object
      │
      ▼
Check Firestore for existing name
      │
      ├── Exists ──► Show "already in library"
      │
      └── New
           │
           ▼
       Add document
           │
           ▼
       Close dialog
```

This prevents a straightforward duplicate from being added to the library.

---

# 18. Google Images Photo Flow

## `screens/google_photo_search_screen.dart`

A major part of the prototype is the user-controlled image selection flow.

The application does **not** automatically search the web and silently attach an image.

Instead:

```text
User chooses "Find Photo"
        │
        ▼
Google Images search
        │
        ▼
User selects an image
        │
        ▼
Image URL returned to Flutter
        │
        ▼
User confirms/grabs photo
        │
        ▼
Caller attaches URL to medicine
```

This makes the photo attachment an explicit user action.

---

# 19. WebView + JavaScript Bridge

On supported native platforms, Google Images is displayed inside a `WebView`.

A JavaScript snippet is injected into the page to intercept image clicks.

The injected script:

1. Detects a click on an `<img>` element.
2. Prevents normal navigation.
3. Resolves the best available image URL.
4. Highlights the selected image.
5. Sends the URL to Flutter through a JavaScript channel.

The communication path is:

```text
Google Images HTML
       │
       ▼
JavaScript click handler
       │
       ▼
PhotoPicker.postMessage(...)
       │
       ▼
Flutter WebView JavaScript channel
       │
       ▼
_selectedUrl
       │
       ▼
"Grab Photo"
```

The implementation attempts to resolve the source image using:

1. Google's `imgurl` query parameter when available
2. `data-src` / `data-iurl`
3. The image's `src` as a final fallback

---

# 20. Web Platform Fallback

`webview_flutter` does not provide the same WebView implementation for Flutter Web, and Google also restricts iframe-style embedding.

Therefore, the web version uses a fallback:

```text
Flutter Web
   │
   ▼
Open Google Images externally
   │
   ▼
User copies image URL
   │
   ▼
Paste URL into the manual entry field
```

This keeps the feature usable across platforms without pretending that the native WebView behavior is available everywhere.

---

# 21. Attaching Photos to Existing Medicines

After the user selects an image, the caller—not the photo search screen—handles persistence.

This separation is intentional.

`GooglePhotoSearchScreen` only answers:

> "Which image URL did the user select?"

Then the calling screen decides what that URL means.

For example:

```text
SearchScreen
    │
    └── GooglePhotoSearchScreen
             │
             └── returns image URL
                    │
                    ▼
             FirebaseMedicineService
                    │
                    ▼
             update Firestore
```

The same pattern is reused by:

- Search results
- Library
- Ingredient results
- Manual medicine entry

---

# 22. Ingredient-Based Search

Each medicine can contain:

```text
substanceName
```

from openFDA's `substance_name` field.

Selecting the ingredient action opens:

```text
IngredientResultsScreen
```

which performs a fresh search using:

```dart
SearchField.ingredient
```

The flow is:

```text
Medicine
   │
   ▼
substanceName
   │
   ▼
IngredientResultsScreen
   │
   ▼
Firestore-first + openFDA search
   │
   ▼
Medicines sharing the ingredient
```

The original search screen remains intact because the ingredient results are pushed as a separate route.

---

# 23. Library

## `screens/library_screen.dart`

The library is backed directly by a Firestore stream.

The service uses:

```dart
snapshots()
```

so the UI can react to Firestore changes.

Conceptually:

```text
Firestore
   │
   │ realtime snapshots
   ▼
FirebaseMedicineService.streamLibrary()
   │
   ▼
Stream<List<Medicine>>
   │
   ▼
StreamBuilder
   │
   ▼
Library UI
```

The library orders documents by `createdAt` descending, so recently added medicines appear first.

---

# 24. Library Actions

Each medicine card can provide actions such as:

- Find/replace a photo
- View medicines sharing the same ingredient
- Delete the medicine

Deletion includes a confirmation dialog before the Firestore document is removed.

---

# 25. Reusable Medicine Card

## `widgets/medicine_card.dart`

`MedicineCard` is a reusable presentation widget.

It displays:

- Medicine image
- Medicine name
- Manufacturer
- Dosage information
- Description
- Image source indicator
- Optional trailing actions
- Optional tap behavior

The card also uses `CachedNetworkImage`.

If no image exists, a medicine icon is displayed instead.

If an image is loading, a progress indicator is displayed.

If an image fails, a broken-image placeholder is shown.

This keeps image handling consistent across search results, library results, and ingredient results.

---

# 26. Theme Management

## `providers/theme_provider.dart`

Theme state is managed through `ThemeProvider`.

Supported modes:

```text
Light
Dark
System
```

The application also supports selectable accent/seed colors.

The theme is generated using:

```dart
ColorScheme.fromSeed(...)
```

and Material 3.

The provider persists:

```text
theme_mode
theme_seed_color
```

using `SharedPreferences`.

Therefore, user theme choices survive application restarts.

---

# 27. Localization

## `providers/locale_provider.dart`

The application supports:

```text
English
Arabic
French
German
Turkish
```

The active locale is stored using `SharedPreferences`.

The localization architecture is:

```text
UI
 │
 ▼
AppLocalizations
 │
 ├── app_en.arb
 ├── app_ar.arb
 ├── app_fr.arb
 ├── app_de.arb
 └── app_tr.arb
```

Only application UI labels and messages are localized.

Medicine content returned from openFDA or entered by the user is treated as data and is not automatically translated.

This distinction prevents externally sourced medicine information from being silently modified by the UI localization system.

---

# 28. State Management

The prototype uses a pragmatic combination of Flutter state mechanisms.

### `Provider`

Used for application-wide preferences:

- Theme
- Locale

### `StatefulWidget`

Used for screen-specific state such as:

- Search query
- Search results
- Loading state
- Error state
- Selected filters
- Photo attachment progress

### `StreamBuilder`

Used for the Firestore-backed library.

This keeps global state small while allowing each screen to own the state that belongs specifically to its workflow.

---

# 29. Loading and Error Handling

The project deliberately distinguishes different stages of work.

For search:

```dart
enum SearchPhase {
  library,
  api,
}
```

The UI can therefore show messages such as:

```text
Searching library...
```

followed by:

```text
Searching API...
```

instead of displaying one generic loading message for the entire process.

---

# 30. Timeouts

Both network and Firestore operations use explicit timeouts.

The API request uses a timeout around the HTTP request.

Firestore operations use a shared timeout constant.

This is particularly important for asynchronous UI operations because a request that remains indefinitely pending can leave the user with a permanent loading indicator.

The intended behavior is:

```text
Request
  │
  ├── Success ──► Update UI
  │
  ├── Error ────► Show error/retry
  │
  └── Timeout ──► Stop loading + inform user
```

---

# 31. Offline / Partial-Failure Behavior

The search service includes a useful fallback:

If:

- Firestore returns cached results
- but the API request fails

the application can still return the cached results.

Conceptually:

```text
Firestore search
      │
      ▼
 cached results
      │
      ├──────── API succeeds ───────► merge results
      │
      └──────── API fails ───────────► return cached results
```

If there are no cached results and the API fails, the error is propagated so the UI can show an error state and offer retry.

---

# 32. Why the Services Are Separated

Instead of putting all logic inside the screens, the application separates external data operations into:

```text
MedicineApiService
FirebaseMedicineService
```

This provides several benefits:

- Screens stay focused on UI and interaction.
- API-specific code is isolated.
- Firestore implementation is isolated.
- The same services can be reused by multiple screens.
- Testing individual data operations becomes easier.
- Future replacement of the API/backend is less invasive.

For example, both `SearchScreen` and `IngredientResultsScreen` can reuse the same search/cache logic instead of implementing separate API flows.

---

# 33. Main End-to-End Workflow

The complete normal search workflow is:

```text
                    USER
                     │
                     ▼
              Enter medicine
                     │
                     ▼
               SearchScreen
                     │
                     ▼
       FirebaseMedicineService
                     │
          ┌──────────┴──────────┐
          ▼                     ▼
      Firestore             openFDA API
      library search            │
          │                     │
          └──────────┬──────────┘
                     ▼
             Merge + de-dupe
                     │
                     ▼
          Cache new API records
                     │
                     ▼
               MedicineCard
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
       Photo      Ingredient   Saved
       search      search      library
```

---

# 34. Example: Searching for a New Medicine

Suppose the user searches for:

```text
Ibuprofen
```

The application:

1. Normalizes the query.
2. Searches the Firestore library.
3. Searches openFDA for matching brand, generic, or substance names.
4. Receives API records.
5. Maps each API record into a `Medicine`.
6. Compares results against existing library entries.
7. Saves missing medicines to Firestore.
8. Returns the merged list.
9. Displays the results using `MedicineCard`.

If the user selects a result and grabs an image:

```text
Result
  ↓
Google Images
  ↓
User selects image
  ↓
Image URL returned
  ↓
Firestore update
  ↓
Card displays image
```

---

# 35. Example: API Does Not Find a Medicine

If no results are returned:

```text
Search
  │
  ▼
No results
  │
  ▼
Add manually
  │
  ▼
Enter medicine details
  │
  ├── Optional image URL
  │
  └── Optional Google image selection
  │
  ▼
Check duplicate
  │
  ▼
Save to Firestore
```

This makes the application useful even when the external API does not contain the medicine the user needs.

---

# 36. Design Decisions Worth Highlighting

### Firestore-first + API-always search

This combines local persistence with fresh external discovery.

### Explicit user-controlled image selection

The application does not silently assign a web image to a medicine. The user chooses the image.

### Reusable service layer

Search and persistence logic is shared instead of duplicated across screens.

### Normalized duplicate checks

Lowercase names make basic case-insensitive duplicate detection straightforward.

### Realtime library

Firestore snapshots keep the library synchronized with database changes.

### Persistent preferences

Theme, accent color, and language survive restarts.

### Platform-aware image search

Native platforms use an in-app WebView while Flutter Web uses an external-browser fallback.

### Explicit async timeouts

Network/database operations cannot leave the interface waiting forever.

---

# 37. Potential Next Steps

Because this was built as a foundation/demo, several areas could be extended for a production implementation.

Possible next steps include:

- Authentication and per-user medicine libraries
- Stronger Firestore security rules
- Repository interfaces and dependency injection
- Unit and widget tests
- Integration tests
- Pagination for large API/library datasets
- More scalable Firestore search/indexing
- Better API caching strategy
- Image download/storage instead of storing external URLs
- Image attribution/licensing handling
- More advanced medicine detail screens
- Better duplicate detection using API IDs and normalized medicine metadata
- Dedicated domain/use-case classes
- Analytics and structured logging
- Retry/backoff strategies
- More robust API query escaping
- Accessibility improvements
- CI/CD and automated quality checks

These changes would make sense as the prototype evolves into a larger production application.

---

# 38. Summary

This prototype demonstrates a complete Flutter application workflow around medicine discovery and organization:

```text
Public API
   ↓
Search
   ↓
Firestore caching
   ↓
Reusable domain model
   ↓
Medicine library
   ↓
User-selected images
   ↓
Ingredient discovery
   ↓
Persistent preferences
   ↓
Localized Material 3 UI
```

The main architectural goal was to establish a clean and extensible foundation before implementing more advanced application-specific functionality.

