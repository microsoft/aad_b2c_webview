import 'package:flutter_test/flutter_test.dart';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';

void main() {
  group('B2CWebViewParams', () {
    test('should initialize with required fields', () {
      final params = B2CWebViewParams(
        tenantBaseUrl: 'https://example.com',
        clientId: 'client_id',
        redirectUrl: 'https://redirect.com',
        userFlowName: 'login',
        scopes: ['openid'],
        isLoginFlow: true,
        containsChallenge: true,
      );

      expect(params.tenantBaseUrl, 'https://example.com');
      expect(params.clientId, 'client_id');
      expect(params.redirectUrl, 'https://redirect.com');
      expect(params.userFlowName, 'login');
      expect(params.scopes, ['openid']);
      expect(params.isLoginFlow, true);
      expect(params.containsChallenge, true);
    });

    test('should handle optional parameters correctly', () {
      final params = B2CWebViewParams(
        tenantBaseUrl: 'https://example.com',
        clientId: 'client_id',
        redirectUrl: 'https://redirect.com',
        userFlowName: 'login',
        scopes: ['openid'],
        isLoginFlow: true,
        containsChallenge: true,
        onHtmlErrorInfo: (error) {
          expect(error, 'Error occurred');
        },
        onHtmlComponents: (components) {
          expect(components, 'Component details');
        },
      );

      // Simulate a callback call
      params.onHtmlErrorInfo?.call('Error occurred');
      params.onHtmlComponents?.call('Component details');
    });

    test('should copyWith correctly', () {
      final originalParams = B2CWebViewParams(
        tenantBaseUrl: 'https://example.com',
        clientId: 'client_id',
        redirectUrl: 'https://redirect.com',
        userFlowName: 'login',
        scopes: ['openid'],
        isLoginFlow: true,
        containsChallenge: true,
      );

      final updatedParams = originalParams.copyWith(
        urlUserFlow: 'https://newurl.com',
        onHtmlErrorInfo: (error) {
          expect(error, 'New error');
        },
      );

      // Assert that the copied object has the updated values and the others are unchanged
      expect(updatedParams.urlUserFlow, 'https://newurl.com');
      expect(updatedParams.tenantBaseUrl, 'https://example.com');
      expect(updatedParams.clientId, 'client_id');
      expect(updatedParams.onHtmlErrorInfo, isNotNull);

      // Simulate a callback for the updated parameter
      updatedParams.onHtmlErrorInfo?.call('New error');
    });

    test('should handle missing optional parameters', () {
      final params = B2CWebViewParams(
        tenantBaseUrl: 'https://example.com',
        clientId: 'client_id',
        redirectUrl: 'https://redirect.com',
        userFlowName: 'login',
        scopes: ['openid'],
        isLoginFlow: true,
        containsChallenge: true,
      );

      expect(params.onHtmlErrorInfo, isNull);
      expect(params.onHtmlComponents, isNull);
    });
  });
}
