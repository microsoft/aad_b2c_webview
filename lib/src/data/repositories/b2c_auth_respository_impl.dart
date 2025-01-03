import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class B2CAuthRepositoryImpl implements B2CAuthRepository {
  final B2CAuthDatasource _datasource;

  B2CAuthRepositoryImpl({
    required B2CAuthDatasource datasource,
  }) : _datasource = datasource;

  @override
  Future<AzureTokenResponseEntity?> refreshTokens(B2CAuthEntity params) async {
    try {
      return await _datasource.refreshTokens(params);
    } catch (error, stack) {
      throw B2CAuthRefreshException(
        error: error,
        trace: stack,
      );
    }
  }

  @override
  Future<AzureTokenResponseEntity?> getAllTokens(B2CAuthEntity params) async {
    try {
      return await _datasource.getAllTokens(params);
    } catch (error, stack) {
      throw B2CAuthGetTokensException(
        error: error,
        trace: stack,
      );
    }
  }
}
