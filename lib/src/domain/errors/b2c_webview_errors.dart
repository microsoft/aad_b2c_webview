import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class ConfigWebViewException extends BaseException {
  ConfigWebViewException({
    required super.error,
    required super.trace,
  });
}

class RunJavaScriptException extends BaseException {
  RunJavaScriptException({
    required super.error,
    required super.trace,
  });
}

class RunJavaScriptReturningException extends BaseException {
  RunJavaScriptReturningException({
    required super.error,
    required super.trace,
  });
}
