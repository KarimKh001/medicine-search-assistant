import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../l10n/app_localizations.dart';

/// Requirement 2, per the supervisor's clarification:
///
///   "the photo should be added when you grab [it from] a search result...
///    the API may not have the medicine I want, so give the user the
///    ability to search for the medicine in Google, then a button to grab
///    the photo he found in the search result. The Google page should
///    open in a window in the app itself."
///
/// This screen opens Google Images (for [medicineName]) inside an in-app
/// WebView. The user browses/taps a photo they like -- tapping doesn't
/// navigate away, it just marks that photo as selected -- then presses the
/// "Grab Photo" button to send its URL back to the caller via
/// `Navigator.pop`. Nothing is attached to Firestore here; the caller
/// (search_screen.dart / library_screen.dart / add_medicine_dialog.dart)
/// decides what to do with the returned URL.
///
/// webview_flutter has no Flutter Web implementation, and embedding Google
/// in an <iframe> on web is blocked by Google's own X-Frame-Options header
/// regardless -- so on web this screen falls back to opening Google Images
/// in a real browser tab and asks the user to copy the image address and
/// paste it into the "Image URL" field instead.
class GooglePhotoSearchScreen extends StatefulWidget {
  final String medicineName;

  const GooglePhotoSearchScreen({super.key, required this.medicineName});

  @override
  State<GooglePhotoSearchScreen> createState() =>
      _GooglePhotoSearchScreenState();
}

class _GooglePhotoSearchScreenState extends State<GooglePhotoSearchScreen> {
  late final Uri _searchUri = Uri.https('www.google.com', '/search', {
    'q': widget.medicineName,
    'tbm': 'isch', // image search
    'igu': '1', // simplified mobile image-grid layout, easier to tap
  });

  WebViewController? _controller;
  String? _selectedUrl;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel(
          'PhotoPicker',
          onMessageReceived: _onPhotoTapped,
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => setState(() => _loading = true),
            onPageFinished: (_) {
              setState(() => _loading = false);
              _controller?.runJavaScript(_tapInterceptorJs);
            },
          ),
        )
        ..loadRequest(_searchUri);
    }
  }

  /// Injected once per page load. Intercepts taps on `<img>` elements so
  /// they select a photo instead of navigating away, and resolves each
  /// image's best available URL:
  ///  1. The classic Google Images `imgurl` query param on the wrapping
  ///     `<a href="/imgres?imgurl=...">` link, when present -- this is the
  ///     full-resolution source image, not the thumbnail.
  ///  2. A `data-src` / `data-iurl` attribute some Google layouts use for
  ///     lazy-loaded full images.
  ///  3. The `<img>` tag's own `src` as a last resort.
  /// The resolved URL is posted back to Flutter through the `PhotoPicker`
  /// JavaScript channel as JSON, and the tapped image gets a visible blue
  /// outline so the user can see what they've selected.
  static const _tapInterceptorJs = '''
(function() {
  if (window.__photoPickerInstalled) { return; }
  window.__photoPickerInstalled = true;
  var lastEl = null;
  function resolveUrl(img) {
    try {
      var a = img.closest('a');
      if (a && a.href) {
        var m = a.href.match(/[?&]imgurl=([^&]+)/);
        if (m && m[1]) { return decodeURIComponent(m[1]); }
      }
    } catch (e) {}
    var ds = img.getAttribute('data-src') || img.getAttribute('data-iurl');
    if (ds) { return ds; }
    return img.src;
  }
  document.addEventListener('click', function(e) {
    var img = e.target && e.target.closest ? e.target.closest('img') : null;
    if (!img) { return; }
    e.preventDefault();
    e.stopPropagation();
    if (lastEl) { lastEl.style.outline = ''; lastEl.style.outlineOffset = ''; }
    img.style.outline = '4px solid #2563EB';
    img.style.outlineOffset = '2px';
    lastEl = img;
    PhotoPicker.postMessage(JSON.stringify({src: resolveUrl(img)}));
  }, true);
})();
''';

  void _onPhotoTapped(JavaScriptMessage message) {
    final l10n = AppLocalizations.of(context)!;
    try {
      final data = jsonDecode(message.message) as Map<String, dynamic>;
      final src = data['src'] as String?;
      if (src == null || !src.startsWith('http')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noPhotoSelectedYet)),
        );
        return;
      }
      setState(() => _selectedUrl = src);
    } catch (_) {
      // Malformed message from the page; ignore and let the user try
      // tapping a different photo.
    }
  }

  Future<void> _openExternally() async {
    await launchUrl(_searchUri, mode: LaunchMode.externalApplication);
  }

  void _grabPhoto() {
    if (_selectedUrl == null) return;
    Navigator.of(context).pop(_selectedUrl);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.googlePhotoSearchTitle),
        actions: [
          if (!kIsWeb)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: l10n.retry,
              onPressed: () => _controller?.reload(),
            ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: l10n.openInBrowserFallback,
            onPressed: _openExternally,
          ),
        ],
      ),
      body: kIsWeb ? _buildWebFallback(theme, l10n) : _buildWebView(theme, l10n),
    );
  }

  Widget _buildWebView(ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: theme.colorScheme.surfaceContainerHigh,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            l10n.tapPhotoHint,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              if (_controller != null) WebViewWidget(controller: _controller!),
              if (_loading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
        _buildGrabBar(theme, l10n),
      ],
    );
  }

  Widget _buildGrabBar(ThemeData theme, AppLocalizations l10n) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 48,
                height: 48,
                color: theme.colorScheme.surfaceContainerHighest,
                child: _selectedUrl == null
                    ? Icon(Icons.image_outlined,
                        color: theme.colorScheme.onSurfaceVariant)
                    : Image.network(
                        _selectedUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.broken_image_outlined,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedUrl == null
                    ? l10n.noPhotoSelectedYet
                    : l10n.tapPhotoHint,
                style: theme.textTheme.bodySmall,
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _selectedUrl == null ? null : _grabPhoto,
              icon: const Icon(Icons.download_outlined),
              label: Text(l10n.grabPhotoButton),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebFallback(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.travel_explore,
                size: 40, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              l10n.webViewUnavailableOnWeb,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _openExternally,
              icon: const Icon(Icons.open_in_new),
              label: Text(l10n.openInBrowserFallback),
            ),
          ],
        ),
      ),
    );
  }
}
