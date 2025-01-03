import 'package:flutter_test/flutter_test.dart';
import 'package:aad_b2c_webview/aad_b2c_webview.dart';

void main() {
  group('HtmlParseEntity', () {
    const mockJson = {
      'name': 'Test Name',
      'id': 'test-id',
      'placeholder': 'Enter something',
      'type': 'input',
      'textContent': 'This is a text',
      'additionalAttributes': {
        'attribute1': 'value1',
        'attribute2': 'value2',
      },
    };

    late HtmlParseEntity htmlParseEntity;

    setUp(() {
      htmlParseEntity = HtmlParseEntity.fromJson(mockJson);
    });

    test('should create an instance of HtmlParseEntity from JSON', () {
      expect(htmlParseEntity.name, 'Test Name');
      expect(htmlParseEntity.id, 'test-id');
      expect(htmlParseEntity.placeholder, 'Enter something');
      expect(htmlParseEntity.textContent, 'This is a text');
      expect(htmlParseEntity.type, HtmlParseType.input);
      expect(htmlParseEntity.additionalAttributes, {
        'attribute1': 'value1',
        'attribute2': 'value2',
      });
    });

    test('getAttribute should return correct value for existing attribute', () {
      final attributeValue = htmlParseEntity.getAttribute('attribute1');
      expect(attributeValue, 'value1');
    });

    test('getAttribute should return empty string for non-existing attribute',
        () {
      final attributeValue = htmlParseEntity.getAttribute('nonExistent');
      expect(attributeValue, '');
    });

    test('containsAttribute should return true for existing attribute', () {
      final contains = htmlParseEntity.containsAttribute('attribute1');
      expect(contains, true);
    });

    test('containsAttribute should return false for non-existing attribute',
        () {
      final contains = htmlParseEntity.containsAttribute('nonExistent');
      expect(contains, false);
    });
  });
}
