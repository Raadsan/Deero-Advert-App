import 'package:deero_advert_app/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaProvider with ChangeNotifier {
  final Map<String, WebViewController> _controllers = {};
  final Map<String, bool> _isInitialized = {};
  final Map<String, bool> _isLoading = {};
  final Map<String, double> _progress = {};

  bool isPlatformLoading(String platform) => _isLoading[platform] ?? true;
  double getPlatformProgress(String platform) => _progress[platform] ?? 0;
  WebViewController getController(String platform) {
    if (!(_isInitialized[platform] ?? false)) {
      initPlatform(platform, 350);
    }
    return _controllers[platform]!;
  }

  static const String _desktopUserAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36';

  String _getPlatformUrl(String platform, double width) {
    switch (platform) {
      case "Facebook":
        int fbWidth = width.toInt().clamp(280, 500);
        return "https://www.facebook.com/plugins/page.php?href=https%3A%2F%2Fwww.facebook.com%2Fprofile.php%3Fid%3D100068912268460&tabs=timeline&width=$fbWidth&height=5000&small_header=true&adapt_container_width=true&hide_cover=true&show_facepile=false";
      case "TikTok":
        return "https://www.tiktok.com/embed/@deeroadverts";
      case "Instagram":
        return kAdvertSocialInstagramUrl;
      case "LinkedIn":
        return kAdvertSocialLinkedInUrl;
      case "Behance":
        return kAdvertSocialBehanceUrl;
      default:
        return "";
    }
  }

  void initPlatform(String platform, double width) {
    if (_isInitialized[platform] ?? false) return;

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white);

    if (platform == "Facebook") {
      controller.setUserAgent(_desktopUserAgent);
    }

    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (_) {
          _isLoading[platform] = true;
          _progress[platform] = 0;
          notifyListeners();
        },
        onProgress: (progress) {
          double newProgress = progress / 100.0;
          if ((newProgress - (_progress[platform] ?? 0)).abs() > 0.1 ||
              progress == 100) {
            _progress[platform] = newProgress;
            notifyListeners();
          }
        },
        onPageFinished: (_) {
          _isLoading[platform] = false;
          _progress[platform] = 1.0;
          _injectCleanerCSS(controller);
          notifyListeners();
        },
        onNavigationRequest: (NavigationRequest request) async {
          if (!request.url.startsWith('http')) {
            try {
              await launchUrl(
                Uri.parse(request.url),
                mode: LaunchMode.externalApplication,
              );
            } catch (_) {}
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );

    controller.loadRequest(Uri.parse(_getPlatformUrl(platform, width)));
    _controllers[platform] = controller;
    _isInitialized[platform] = true;
    _isLoading[platform] = true;
    notifyListeners();
  }

  void refreshPlatform(String platform, double width) {
    _controllers[platform]?.loadRequest(
      Uri.parse(_getPlatformUrl(platform, width)),
    );
  }

  void _injectCleanerCSS(WebViewController controller) {
    controller.runJavaScript('''
      (function() {
        var style = document.createElement('style');
        style.innerHTML = `
          [class*="DivHeaderContainer"], 
          [class*="DivShareLayoutHeader"],
          header, footer, nav, 
          .tiktok-header, 
          [class*="ButtonLogin"], 
          [class*="DivLoginContainer"] { 
            display: none !important; 
          }
          
          html, body { 
            margin: 0 !important; 
            padding: 0 !important; 
            padding-top: 25px !important; 
            width: 100% !important;
            overflow-x: hidden !important;
            background: white !important;
            display: block !important;
          }

          iframe { 
            width: 100% !important;
            height: 100% !important;
            max-width: 100% !important;
            margin: 0 !important;
            padding: 0 !important;
          }

          .fb_iframe_widget, .fb_iframe_widget span, .fb-page {
            width: 100% !important;
            height: auto !important;
            max-width: 100% !important;
            margin: 0 !important;
          }
        `;
        document.head.appendChild(style);
      })();
    ''');
  }

  // Legacy getters for compatibility during migration
  bool get isFacebookLoading => isPlatformLoading("Facebook");
  bool get isTiktokLoading => isPlatformLoading("TikTok");
  double get fbProgress => getPlatformProgress("Facebook");
  double get ttProgress => getPlatformProgress("TikTok");
  WebViewController get facebookController => getController("Facebook");
  WebViewController get tiktokController => getController("TikTok");
}
