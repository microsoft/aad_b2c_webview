import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockPkcePair extends Mock implements PkcePair {}

class MockB2CRestClient extends Mock implements B2CRestClient {}

void main() {
  late B2CAuthDatasourceImpl datasource;
  late MockB2CRestClient mockClient;
  late MockPkcePair mockPkcePair;

  setUp(() {
    mockClient = MockB2CRestClient();
    mockPkcePair = MockPkcePair();
    datasource = B2CAuthDatasourceImpl(
      pkcePairInstance: mockPkcePair,
      client: mockClient,
    );
  });

  group('B2CAuthDatasourceImpl', () {
    const testTenantBaseUrl = 'https://example.com';
    const testUserFlowName = 'testUserFlow';

    final params = B2CAuthEntity(
      tenantBaseUrl: testTenantBaseUrl,
      userFlowName: testUserFlowName,
      clientId: 'test-client-id',
      refreshToken: 'test-refresh-token',
      authCode: 'test-auth-code',
      grantType: 'authorization_code',
      redirectUri: 'https://redirect.uri',
      providedScopes: 'openid profile',
    );

    setUpAll(() {
      // Register fallback values for mocktail
      registerFallbackValue(Uri());
      registerFallbackValue({});
    });

    test('refreshTokens returns token on successful response', () async {
      // Arrange
      const expectedResponse = {
        'access_token': 'test-access-token',
        'refresh_token': 'test-refresh-token',
      };
      final jsonResponse = jsonEncode(expectedResponse);

      when(() => mockClient.post(
            url: any(named: 'url'),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => RestClientResponse(
            body: jsonResponse,
            statusCode: 200,
          ));

      // Act
      final result = await datasource.refreshTokens(params);

      // Assert
      expect(result, isNotNull);
      expect(result?.accessToken, 'test-access-token');
      expect(result?.refreshToken, 'test-refresh-token');
    });
    test('refreshTokens throws exception on invalid response', () async {
      // Arrange
      when(() => mockPkcePair.codeVerifier).thenReturn('test-code-verifier');
      when(() => mockClient.post(
            url: any(named: 'url'),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => RestClientResponse(
            body: 'Invalid request',
            statusCode: 400,
          ));

      // Act & Assert
      expect(
        () async => await datasource.getAllTokens(params),
        throwsA(isA<B2CAuthWithoutParamsException>()),
      );
    });

    test('getAllTokens returns token on successful response', () async {
      // Arrange
      const expectedResponse = {
        'access_token': 'test-access-token',
        'refresh_token': 'test-refresh-token',
      };
      final jsonResponse = jsonEncode(expectedResponse);

      when(() => mockPkcePair.codeVerifier).thenReturn('test-code-verifier');
      when(() => mockClient.post(
            url: any(named: 'url'),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => RestClientResponse(
            body: jsonResponse,
            statusCode: 200,
          ));

      // Act
      final result = await datasource.getAllTokens(params);

      // Assert
      expect(result, isNotNull);
      expect(result?.accessToken, 'test-access-token');
      expect(result?.refreshToken, 'test-refresh-token');
    });

    test('getAllTokens throws exception when parameters are missing', () async {
      // Arrange
      final invalidParams = B2CAuthEntity(
        tenantBaseUrl: '',
        userFlowName: '',
        clientId: 'test-client-id',
        refreshToken: 'test-refresh-token',
        authCode: 'test-auth-code',
        grantType: 'authorization_code',
        redirectUri: 'https://redirect.uri',
        providedScopes: 'openid profile',
      );

      // Act & Assert
      expect(
        () => datasource.getAllTokens(invalidParams),
        throwsA(isA<B2CAuthWithoutParamsException>()),
      );
    });

    test('refreshTokens throws exception on network error', () async {
      // Arrange
      when(() => mockClient.post(
            url: any(named: 'url'),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          )).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => datasource.refreshTokens(params),
        throwsA(isA<Exception>()),
      );
    });
  });
}
