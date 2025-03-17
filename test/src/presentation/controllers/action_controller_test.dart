import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';

class MockB2CWebViewRepository extends Mock implements B2CWebViewRepository {}

void main() {
  late ActionController actionController;
  late MockB2CWebViewRepository mockB2CWebViewRepository;

  setUp(() {
    mockB2CWebViewRepository = MockB2CWebViewRepository();
    actionController =
        ActionController(b2cWebViewRepository: mockB2CWebViewRepository);
  });

  group('ActionController', () {
    test('should insert values and click button correctly', () async {
      final listIdValue = [
        ActionEntity(id: 'input1', value: 'test value 1'),
        ActionEntity(id: 'input2', value: 'test value 2'),
      ];
      const buttonId = 'submitButton';

      // Mock the behavior of runJavaScript
      when(() => mockB2CWebViewRepository.runJavaScript(any()))
          .thenAnswer((_) async {});

      // Call the method
      await actionController.insertAndClick(
        listIdValue: listIdValue,
        buttonId: buttonId,
      );

      // Verify that runJavaScript was called with the correct JavaScript code
      verify(() => mockB2CWebViewRepository.runJavaScript(
          "document.getElementById('input1').value = 'test value 1';"
          "document.getElementById('input2').value = 'test value 2';"
          "document.getElementById('submitButton').click();")).called(1);
    });

    test('should handle empty listIdValue in insertAndClick', () async {
      const buttonId = 'submitButton';

      when(() => mockB2CWebViewRepository.runJavaScript(any()))
          .thenAnswer((_) async {});

      await actionController.insertAndClick(
        listIdValue: [],
        buttonId: buttonId,
      );

      // Verify that runJavaScript was called with only the click code
      verify(() => mockB2CWebViewRepository.runJavaScript(
          "document.getElementById('submitButton').click();")).called(1);
    });

    test('should sync the page correctly', () async {
      // Mock runJavaScript calls
      when(() => mockB2CWebViewRepository.runJavaScript(any()))
          .thenAnswer((_) async {});

      // Call the method
      await actionController.syncPage();

      // Verify that runJavaScript was called with the necessary code
      verify(() => mockB2CWebViewRepository
          .runJavaScript(FlutterJs.jsFunctionToGetAlert)).called(1);
      verify(() => mockB2CWebViewRepository
          .runJavaScript(FlutterJs.jsFunctionToGetComponents)).called(1);
    });

    test('should call getCustomAlerts correctly', () async {
      final customAlert = FlutterJsCustomAlert(
        type: JsDocumentType.byClassName,
        code: '.errorClass',
        conditions: {'aria-hidden': 'false'},
      );

      when(() => mockB2CWebViewRepository.runJavaScript(any()))
          .thenAnswer((_) async {});

      await actionController.getCustomAlerts([customAlert]);

      // Verify that runJavaScript was called with the correct custom alert JS function
      verify(() => mockB2CWebViewRepository.runJavaScript(
          FlutterJs.jsFunctionToGetCustomAlert(params: customAlert))).called(1);
    });

    test('should throw exception when insertAndClick fails', () async {
      final listIdValue = [
        ActionEntity(id: 'input1', value: 'test value 1'),
        ActionEntity(id: 'input2', value: 'test value 2'),
      ];
      const buttonId = 'submitButton';

      // Simulate an error in runJavaScript
      when(() => mockB2CWebViewRepository.runJavaScript(any()))
          .thenThrow(Exception('JavaScript execution error'));

      expect(
        () async => await actionController.insertAndClick(
          listIdValue: listIdValue,
          buttonId: buttonId,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when syncPage fails', () async {
      // Simulate an error in runJavaScript
      when(() => mockB2CWebViewRepository.runJavaScript(any()))
          .thenThrow(Exception('JavaScript execution error'));

      expect(
        () async => await actionController.syncPage(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
