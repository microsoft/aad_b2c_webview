import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/foundation.dart';

class B2CWebViewDatasourceImpl implements B2CWebViewDatasource {
  final WebViewControllersHelper _controllers;
  final B2CWebViewHelper _helper;

  B2CWebViewDatasourceImpl({
    required WebViewControllersHelper controllers,
    required B2CWebViewHelper helper,
  })  : _controllers = controllers,
        _helper = helper;

  @override
  Future<void> runJavaScript(String code) async {
    try {
      if (kIsWeb) {
        await _controllers.web.runJavaScript(code);
      } else {
        await _controllers.mobile.runJavaScript(code);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Object> runJavaScriptReturningResult(String code) async {
    try {
      if (kIsWeb) {
        return await _controllers.web.runJavaScriptReturningResult(code);
      } else {
        return await _controllers.mobile.runJavaScriptReturningResult(code);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> initializeMobile(B2CWebViewParams params) async {
    try {
      _controllers.mobile
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(params.webViewBackgroundColor)
        ..setUserAgent(params.userAgent)
        ..clearCache()
        ..addJavaScriptChannel(
          FlutterJs.jsFlutterAlertChannel,
          onMessageReceived: (result) {
            if (params.onHtmlErrorInfo != null) {
              params.onHtmlErrorInfo!(result.message);
            }
          },
        )
        ..addJavaScriptChannel(
          FlutterJs.jsFlutterComponentChannel,
          onMessageReceived: (result) {
            if (params.onHtmlComponents != null) {
              params.onHtmlComponents!(result.message);
            }
          },
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) async {
              if (url.isNotEmpty) {
                _helper.checkPage(params: params, url: url);
              }
              if (params.onHtmlUrlChange != null) {
                params.onHtmlUrlChange!(url);
              }
              if (Check.isLink(url)) {
                await _pollUntilPageLoaded(params);
              }
            },
          ),
        );
      await _controllers.mobile.loadRequest(Uri.parse(params.urlUserFlow));

      if (_controllers.mobile.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (_controllers.mobile.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> initializeWeb(B2CWebViewParams params) async {}

  Future<void> _pollUntilPageLoaded(B2CWebViewParams params) async {
    final int maxDurationInMillis = params.timeOutInMillis ?? 5000;
    const int pollingIntervalInMillis = 200;
    int elapsedTime = 0;

    while (elapsedTime < maxDurationInMillis) {
      final result = await _controllers.mobile.runJavaScriptReturningResult(
        FlutterJs.jsFunctionCheckComponentsOnScreen,
      );

      if (result == true) {
        await _controllers.mobile.runJavaScript(FlutterJs.jsFunctionToGetAlert);
        await _controllers.mobile.runJavaScript(
          FlutterJs.jsFunctionToGetComponents,
        );
        return;
      } else {
        await Future.delayed(
          const Duration(
            milliseconds: pollingIntervalInMillis,
          ),
        );
        elapsedTime += pollingIntervalInMillis;
      }
    }

    /// Maximum time reached
    if (params.onHtmlErrorInfo != null) {
      params.onHtmlErrorInfo!('Maximum time reached');
    }
  }
}
