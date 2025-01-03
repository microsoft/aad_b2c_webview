import 'package:aad_b2c_webview/aad_b2c_webview.dart';

abstract interface class B2CAuthDatasource {
  Future<AzureTokenResponseEntity?> refreshTokens(B2CAuthEntity params);
  Future<AzureTokenResponseEntity?> getAllTokens(B2CAuthEntity params);
}
