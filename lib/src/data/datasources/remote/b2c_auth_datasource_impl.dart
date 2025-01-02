import 'dart:convert';

import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class B2CAuthDatasourceImpl implements B2CAuthDatasource {
  final PkcePair _pkcePairInstance;
  final B2CRestClient _client;

  B2CAuthDatasourceImpl({
    required PkcePair pkcePairInstance,
    required B2CRestClient client,
  })  : _pkcePairInstance = pkcePairInstance,
        _client = client;

  static const _formUrlEncodedContentType = "application/x-www-form-urlencoded";

  @override
  Future<AzureTokenResponseEntity?> refreshTokens(B2CAuthEntity params) async {
    final String tenantBaseUrl = params.tenantBaseUrl ?? '';
    final String userFlowName = params.userFlowName ?? '';

    if (tenantBaseUrl.isEmpty || userFlowName.isEmpty) {
      throw B2CAuthWithoutParamsException(
        error: 'tenantBaseUrl=$tenantBaseUrl\nuserFlowName=$userFlowName',
        trace: StackTrace.current,
      );
    }

    final url = Uri.parse('$tenantBaseUrl/$userFlowName/$urlEnding').toString();

    final Map<String, dynamic> body = {
      'grant_type': Constants.refreshToken,
      'scope': Constants.defaultScopes,
      'client_id': params.clientId,
      'refresh_token': params.refreshToken,
    };

    final response = await _client.post(
      url: url,
      body: body,
      headers: headers,
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final json = jsonDecode(response.body);
      return AzureTokenResponseEntity.fromJson(json);
    } else {
      return null;
    }
  }

  @override
  Future<AzureTokenResponseEntity?> getAllTokens(B2CAuthEntity params) async {
    final String tenantBaseUrl = params.tenantBaseUrl ?? '';
    final String userFlowName = params.userFlowName ?? '';

    if (tenantBaseUrl.isEmpty || userFlowName.isEmpty) {
      throw B2CAuthWithoutParamsException(
        error: 'tenantBaseUrl=$tenantBaseUrl\nuserFlowName=$userFlowName',
        trace: StackTrace.current,
      );
    }

    final url = Uri.parse('$tenantBaseUrl/$userFlowName/$urlEnding').toString();
    final Map<String, dynamic> body = {
      'grant_type': params.grantType,
      'scope': params.providedScopes,
      'code': params.authCode,
      'client_id': params.clientId,
      'code_verifier': _pkcePairInstance.codeVerifier,
      'redirect_uri': params.redirectUri,
    };

    final response = await _client.post(
      url: url,
      body: body,
      headers: headers,
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final json = jsonDecode(response.body);
      return AzureTokenResponseEntity.fromJson(json);
    } else {
      throw B2CAuthWithoutParamsException(
        error: 'statusCode=${response.statusCode}\nbody=${response.body}',
        trace: StackTrace.current,
      );
    }
  }

  String get urlEnding => Constants.userGetTokenUrlEnding;

  Map<String, String> get headers =>
      {"Content-Type": _formUrlEncodedContentType};
}
