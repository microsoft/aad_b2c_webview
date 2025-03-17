import 'package:aad_b2c_webview/aad_b2c_webview.dart';

abstract interface class B2CWebViewDatasource {
  Future<void> initializeMobile(B2CWebViewParams params);
  Future<void> initializeWeb(B2CWebViewParams params);
  Future<void> runJavaScript(String code);
  Future<Object> runJavaScriptReturningResult(String code);
}
