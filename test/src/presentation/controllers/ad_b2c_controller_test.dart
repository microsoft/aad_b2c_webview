import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';

// Mock classes
class MockB2CAuthRepository extends Mock implements B2CAuthRepository {}

class MockB2CWebViewRepository extends Mock implements B2CWebViewRepository {}

class MockWebViewControllersHelper extends Mock
    implements WebViewControllersHelper {}

void main() {
  late AADB2CController adb2CController;
  late MockB2CAuthRepository mockB2CAuthRepository;
  late MockB2CWebViewRepository mockB2CWebViewRepository;
  late MockWebViewControllersHelper mockWebViewControllersHelper;

  setUp(() {
    mockB2CAuthRepository = MockB2CAuthRepository();
    mockB2CWebViewRepository = MockB2CWebViewRepository();
    mockWebViewControllersHelper = MockWebViewControllersHelper();
    adb2CController = AADB2CController(
      b2cAuthRepository: mockB2CAuthRepository,
      b2cWebViewRepository: mockB2CWebViewRepository,
      webviewController: mockWebViewControllersHelper,
    );
  });

  group('AADB2CController', () {
    test('should initialize webview correctly', () async {
      final params = B2CWebViewParams(
          tenantBaseUrl: 'https://example.com',
          clientId: 'clientId',
          redirectUrl: 'https://redirect.com',
          userFlowName: 'userFlow',
          scopes: ['scope'],
          isLoginFlow: true,
          containsChallenge: true);

      when(() => mockB2CWebViewRepository.initialize(params))
          .thenAnswer((_) async => true);

      await adb2CController.initWebView(params);

      verify(() => mockB2CWebViewRepository.initialize(params)).called(1);
    });

    test('should remove JavaScript channels when reinitializing', () async {
      final params = B2CWebViewParams(
          tenantBaseUrl: 'https://example.com',
          clientId: 'clientId',
          redirectUrl: 'https://redirect.com',
          userFlowName: 'userFlow',
          scopes: ['scope'],
          isLoginFlow: true,
          containsChallenge: true);

      when(() => mockB2CWebViewRepository.initialize(params))
          .thenAnswer((_) async => true);

      when(() => mockWebViewControllersHelper.mobile
          .removeJavaScriptChannel(any())).thenAnswer((_) async {});

      await adb2CController.initWebView(params);

      verify(() => mockB2CWebViewRepository.initialize(params)).called(1);
    });

    test('should refresh token correctly', () async {
      final authEntity = B2CAuthEntity(
        clientId: 'client_id',
        redirectUri: 'https://example.com',
        grantType: 'authorization_code',
      );

      final response = AzureTokenResponseEntity(
        accessToken: 'access_token',
        refreshToken: 'refresh_token',
        refreshTokenExpireTime: 3600,
      );

      when(() => mockB2CAuthRepository.refreshTokens(authEntity))
          .thenAnswer((_) async => response);

      final result = await adb2CController.refreshToken(authEntity);

      expect(result, equals(response));
      verify(() => mockB2CAuthRepository.refreshTokens(authEntity)).called(1);
    });

    test('should throw an error if refresh token fails', () async {
      final authEntity = B2CAuthEntity(
        clientId: 'client_id',
        redirectUri: 'https://example.com',
        grantType: 'authorization_code',
      );

      when(() => mockB2CAuthRepository.refreshTokens(authEntity))
          .thenThrow(Exception('Token refresh failed'));

      expect(
        () async => await adb2CController.refreshToken(authEntity),
        throwsA(isA<Exception>()),
      );
    });
  });
}
