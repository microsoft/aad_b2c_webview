import 'package:aad_b2c_webview/aad_b2c_webview.dart';

abstract interface class B2CRestClient {
  Future<RestClientResponse> post({
    required String url,
    Object? body,
    Map<String, String>? headers,
  });
}

class B2CRestClientImpl implements B2CRestClient {
  final Client _clientHttp;
  B2CRestClientImpl({required Client clientHttp}) : _clientHttp = clientHttp;

  @override
  Future<RestClientResponse> post({
    required String url,
    Object? body,
    Map<String, String>? headers,
  }) async {
    final Response response = await _clientHttp.post(
      Uri.parse(url),
      body: body,
      headers: headers,
    );
    return RestClientResponse(
      body: response.body,
      statusCode: response.statusCode,
    );
  }
}
