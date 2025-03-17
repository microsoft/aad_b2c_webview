import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class B2CAuthRefreshException extends BaseException {
  B2CAuthRefreshException({
    required super.error,
    required super.trace,
  });
}

class B2CAuthGetTokensException extends BaseException {
  B2CAuthGetTokensException({
    required super.error,
    required super.trace,
  });
}

class B2CAuthWithoutParamsException extends BaseException {
  B2CAuthWithoutParamsException({
    required super.error,
    required super.trace,
  });
}
