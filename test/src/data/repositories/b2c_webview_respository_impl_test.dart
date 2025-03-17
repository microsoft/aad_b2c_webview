import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';

// Mock classes for dependencies
class MockB2CWebViewDatasource extends Mock implements B2CWebViewDatasource {}

class MockB2CWebViewHelper extends Mock implements B2CWebViewHelper {}

void main() {
  late B2CWebViewRepositoryImpl repository;
  late MockB2CWebViewDatasource mockDatasource;
  late MockB2CWebViewHelper mockHelper;

  setUp(() {
    mockDatasource = MockB2CWebViewDatasource();
    mockHelper = MockB2CWebViewHelper();
    repository = B2CWebViewRepositoryImpl(
      datasource: mockDatasource,
      helper: mockHelper,
    );
  });

  group('B2CWebViewRepositoryImpl', () {
    const testTenantBaseUrl = 'https://example.com';
    const testUserFlowName = 'testUserFlow';

    final params = B2CWebViewParams(
      tenantBaseUrl: testTenantBaseUrl,
      userFlowName: testUserFlowName,
      clientId: 'test-client-id',
      redirectUrl: 'https://redirect.uri',
      scopes: ['openid'],
      isLoginFlow: true,
      containsChallenge: true,
    );

    test('initialize should throw ConfigWebViewException on error', () async {
      // Arrange
      when(() => mockHelper.getUserFlowUrl(params: params))
          .thenThrow(Exception('Initialization failed'));

      // Act & Assert
      expect(
        () async => await repository.initialize(params),
        throwsA(isA<ConfigWebViewException>()),
      );
    });

    test('runJavaScript should throw RunJavaScriptException on error',
        () async {
      // Arrange
      const code = 'console.log("Hello")';
      when(() => mockDatasource.runJavaScript(code))
          .thenThrow(Exception('JavaScript error'));

      // Act & Assert
      expect(
        () async => await repository.runJavaScript(code),
        throwsA(isA<RunJavaScriptException>()),
      );
    });

    test('runJavaScriptReturningResult should return result successfully',
        () async {
      // Arrange
      const code = 'return 42';
      when(() => mockDatasource.runJavaScriptReturningResult(code))
          .thenAnswer((_) async => 42);

      // Act
      final result = await repository.runJavaScriptReturningResult(code);

      // Assert
      verify(() => mockDatasource.runJavaScriptReturningResult(code)).called(1);
      expect(result, 42);
    });

    test(
        'runJavaScriptReturningResult should throw RunJavaScriptException on error',
        () async {
      // Arrange
      const code = 'return 42';
      when(() => mockDatasource.runJavaScriptReturningResult(code))
          .thenThrow(Exception('JavaScript result error'));

      // Act & Assert
      expect(
        () async => await repository.runJavaScriptReturningResult(code),
        throwsA(isA<RunJavaScriptException>()),
      );
    });
  });
}
