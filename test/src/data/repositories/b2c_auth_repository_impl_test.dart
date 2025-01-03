import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class MockB2CAuthDatasource extends Mock implements B2CAuthDatasource {}

void main() {
  late B2CAuthRepositoryImpl repository;
  late MockB2CAuthDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockB2CAuthDatasource();
    repository = B2CAuthRepositoryImpl(datasource: mockDatasource);
  });

  group('B2CAuthRepositoryImpl', () {
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

    test('refreshTokens returns token on successful response', () async {
      // Arrange
      const expectedResponse = {
        'access_token': 'test-access-token',
        'refresh_token': 'test-refresh-token',
      };
      final jsonResponse = AzureTokenResponseEntity.fromJson(expectedResponse);

      when(() => mockDatasource.refreshTokens(params))
          .thenAnswer((_) async => jsonResponse);

      // Act
      final result = await repository.refreshTokens(params);

      // Assert
      expect(result, isNotNull);
      expect(result?.accessToken, 'test-access-token');
      expect(result?.refreshToken, 'test-refresh-token');
    });

    test('refreshTokens throws B2CAuthRefreshException on error', () async {
      // Arrange
      when(() => mockDatasource.refreshTokens(params))
          .thenThrow(Exception('Some error'));

      // Act & Assert
      expect(
        () => repository.refreshTokens(params),
        throwsA(isA<B2CAuthRefreshException>()),
      );
    });

    test('getAllTokens returns token on successful response', () async {
      // Arrange
      const expectedResponse = {
        'access_token': 'test-access-token',
        'refresh_token': 'test-refresh-token',
      };
      final jsonResponse = AzureTokenResponseEntity.fromJson(expectedResponse);

      when(() => mockDatasource.getAllTokens(params))
          .thenAnswer((_) async => jsonResponse);

      // Act
      final result = await repository.getAllTokens(params);

      // Assert
      expect(result, isNotNull);
      expect(result?.accessToken, 'test-access-token');
      expect(result?.refreshToken, 'test-refresh-token');
    });

    test('getAllTokens throws B2CAuthGetTokensException on error', () async {
      // Arrange
      when(() => mockDatasource.getAllTokens(params))
          .thenThrow(Exception('Some error'));

      // Act & Assert
      expect(
        () => repository.getAllTokens(params),
        throwsA(isA<B2CAuthGetTokensException>()),
      );
    });
  });
}
