import 'package:flutter_test/flutter_test.dart';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';

void main() {
  group('B2CAuthEntity', () {
    const testRedirectUri = 'https://redirect.uri';
    const testClientId = 'test-client-id';
    const testAuthCode = 'authCode';
    const testProvidedScopes = 'openid profile';
    const testUserFlowName = 'testUserFlow';
    const testTenantBaseUrl = 'https://example.com';
    const testRefreshToken = 'test-refresh-token';

    test('Constructor should initialize parameters correctly', () {
      // Arrange
      final authEntity = B2CAuthEntity(
        redirectUri: testRedirectUri,
        clientId: testClientId,
        authCode: testAuthCode,
        providedScopes: testProvidedScopes,
        userFlowName: testUserFlowName,
        tenantBaseUrl: testTenantBaseUrl,
        refreshToken: testRefreshToken,
      );

      // Assert
      expect(authEntity.redirectUri, testRedirectUri);
      expect(authEntity.clientId, testClientId);
      expect(authEntity.authCode, testAuthCode);
      expect(authEntity.providedScopes, testProvidedScopes);
      expect(authEntity.userFlowName, testUserFlowName);
      expect(authEntity.tenantBaseUrl, testTenantBaseUrl);
      expect(authEntity.refreshToken, testRefreshToken);
      expect(authEntity.grantType, Constants.defaultGrantType); // Default value
    });

    test('Constructor should use default grantType when not provided', () {
      // Arrange
      final authEntity = B2CAuthEntity(
        redirectUri: testRedirectUri,
        clientId: testClientId,
        authCode: testAuthCode,
        providedScopes: testProvidedScopes,
        userFlowName: testUserFlowName,
        tenantBaseUrl: testTenantBaseUrl,
      );

      // Assert
      expect(authEntity.grantType, Constants.defaultGrantType); // Default value
    });

    test('Constructor should correctly handle custom grantType', () {
      // Arrange
      const customGrantType = 'client_credentials';
      final authEntity = B2CAuthEntity(
        redirectUri: testRedirectUri,
        clientId: testClientId,
        authCode: testAuthCode,
        providedScopes: testProvidedScopes,
        userFlowName: testUserFlowName,
        tenantBaseUrl: testTenantBaseUrl,
        grantType: customGrantType,
      );

      // Assert
      expect(authEntity.grantType, customGrantType); // Custom grantType
    });

    test('should correctly initialize with missing optional parameters', () {
      // Arrange
      final authEntity = B2CAuthEntity(
        clientId: testClientId,
        authCode: testAuthCode,
      );

      // Assert
      expect(authEntity.clientId, testClientId);
      expect(authEntity.authCode, testAuthCode);
      expect(authEntity.redirectUri, isNull); // Default value (null)
      expect(authEntity.providedScopes, isNull); // Default value (null)
      expect(authEntity.userFlowName, isNull); // Default value (null)
      expect(authEntity.tenantBaseUrl, isNull); // Default value (null)
      expect(authEntity.refreshToken, isNull); // Default value (null)
      expect(authEntity.grantType, Constants.defaultGrantType); // Default value
    });

    test('should copy entity with updated parameters', () {
      // Arrange
      final originalEntity = B2CAuthEntity(
        redirectUri: testRedirectUri,
        clientId: testClientId,
        authCode: testAuthCode,
        providedScopes: testProvidedScopes,
        userFlowName: testUserFlowName,
        tenantBaseUrl: testTenantBaseUrl,
        refreshToken: testRefreshToken,
      );

      // Act
      final copiedEntity = originalEntity.copyWith(
        redirectUri: 'https://new-redirect.uri',
        providedScopes: 'newScope',
      );

      // Assert
      expect(copiedEntity.redirectUri, 'https://new-redirect.uri');
      expect(copiedEntity.providedScopes, 'newScope');
      expect(copiedEntity.clientId, testClientId);
      expect(copiedEntity.authCode, testAuthCode);
      expect(copiedEntity.userFlowName, testUserFlowName);
      expect(copiedEntity.tenantBaseUrl, testTenantBaseUrl);
      expect(copiedEntity.refreshToken, testRefreshToken);
      expect(
          copiedEntity.grantType, Constants.defaultGrantType); // Default value
    });

    test(
        'should return default values for missing optional parameters in copyWith',
        () {
      // Arrange
      final originalEntity = B2CAuthEntity(
        redirectUri: testRedirectUri,
        clientId: testClientId,
      );

      // Act
      final copiedEntity = originalEntity.copyWith();

      // Assert
      expect(copiedEntity.redirectUri, testRedirectUri);
      expect(copiedEntity.clientId, testClientId);
      expect(copiedEntity.authCode, isNull); // Default value (null)
      expect(copiedEntity.providedScopes, isNull); // Default value (null)
      expect(copiedEntity.userFlowName, isNull); // Default value (null)
      expect(copiedEntity.tenantBaseUrl, isNull); // Default value (null)
      expect(copiedEntity.refreshToken, isNull); // Default value (null)
      expect(
          copiedEntity.grantType, Constants.defaultGrantType); // Default value
    });
  });
}
