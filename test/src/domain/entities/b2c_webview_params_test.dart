import 'package:flutter_test/flutter_test.dart';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/material.dart';

void main() {
  group('B2CWebViewParams', () {
    const testTenantBaseUrl = 'https://example.com';
    const testClientId = 'test-client-id';
    const testRedirectUrl = 'https://redirect.uri';
    const testUserFlowName = 'testUserFlow';
    const testScopes = ['openid', 'profile'];
    const testIsLoginFlow = true;
    const testContainsChallenge = true;

    test('Constructor should initialize parameters correctly', () {
      // Arrange
      final params = B2CWebViewParams(
        tenantBaseUrl: testTenantBaseUrl,
        clientId: testClientId,
        redirectUrl: testRedirectUrl,
        userFlowName: testUserFlowName,
        scopes: testScopes,
        isLoginFlow: testIsLoginFlow,
        containsChallenge: testContainsChallenge,
      );

      // Assert
      expect(params.tenantBaseUrl, testTenantBaseUrl);
      expect(params.clientId, testClientId);
      expect(params.redirectUrl, testRedirectUrl);
      expect(params.userFlowName, testUserFlowName);
      expect(params.scopes, testScopes);
      expect(params.isLoginFlow, testIsLoginFlow);
      expect(params.containsChallenge, testContainsChallenge);
    });

    test('copyWith should return a modified copy of the params', () {
      // Arrange
      final originalParams = B2CWebViewParams(
        tenantBaseUrl: testTenantBaseUrl,
        clientId: testClientId,
        redirectUrl: testRedirectUrl,
        userFlowName: testUserFlowName,
        scopes: testScopes,
        isLoginFlow: testIsLoginFlow,
        containsChallenge: testContainsChallenge,
      );

      // Act
      final copiedParams = originalParams.copyWith(
        urlUserFlow: 'new-url',
        onHtmlErrorInfo: (error) => debugPrint(error),
      );

      // Assert
      expect(copiedParams.urlUserFlow, 'new-url');
      expect(copiedParams.onHtmlErrorInfo, isNotNull);
      expect(copiedParams.tenantBaseUrl, testTenantBaseUrl);
      expect(copiedParams.clientId, testClientId);
    });

    test('copyWith should retain unchanged parameters', () {
      // Arrange
      final originalParams = B2CWebViewParams(
        tenantBaseUrl: testTenantBaseUrl,
        clientId: testClientId,
        redirectUrl: testRedirectUrl,
        userFlowName: testUserFlowName,
        scopes: testScopes,
        isLoginFlow: testIsLoginFlow,
        containsChallenge: testContainsChallenge,
      );

      // Act
      final copiedParams = originalParams.copyWith(
        urlUserFlow: 'new-url',
      );

      // Assert
      expect(copiedParams.redirectUrl, testRedirectUrl); // Unchanged
      expect(copiedParams.userFlowName, testUserFlowName); // Unchanged
    });

    test('should initialize with default values for optional parameters', () {
      // Arrange
      final params = B2CWebViewParams(
        tenantBaseUrl: testTenantBaseUrl,
        clientId: testClientId,
        redirectUrl: testRedirectUrl,
        userFlowName: testUserFlowName,
        scopes: testScopes,
        isLoginFlow: testIsLoginFlow,
        containsChallenge: testContainsChallenge,
      );

      // Assert
      expect(params.promptType, Constants.promptTypeLogin);
      expect(params.responseType, Constants.defaultResponseType);
      expect(params.webViewBackgroundColor, Colors.white);
      expect(params.loadingReplacement, isNull);
      expect(params.timeOutInMillis, isNull);
    });
  });
}
