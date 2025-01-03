import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/cupertino.dart';

class HtmlParseEntity {
  final String name;
  final String id;
  final String placeholder;
  final HtmlParseType type;
  final String textContent;
  final Map<String, String> additionalAttributes;

  HtmlParseEntity({
    required this.name,
    required this.id,
    required this.placeholder,
    required this.type,
    required this.textContent,
    required this.additionalAttributes,
  });

  String getAttribute(String key) {
    try {
      return additionalAttributes[key] ?? '';
    } catch (error, trace) {
      debugPrint('Error: $error\nTrace:$trace');
      return '';
    }
  }

  bool containsAttribute(String key) {
    try {
      return additionalAttributes.containsKey(key);
    } catch (error, trace) {
      debugPrint('Error: $error\nTrace:$trace');
      return false;
    }
  }

  factory HtmlParseEntity.fromJson(Map<String, dynamic>? json) {
    return HtmlParseEntity(
      name: json?['name'] ?? '',
      id: json?['id'] ?? '',
      placeholder: json?['placeholder'] ?? '',
      textContent: json?['textContent'] ?? '',
      type: (json?['type'] ?? '').toString().convertToType(),
      additionalAttributes: Map<String, String>.from(
        json?['additionalAttributes'] ?? {},
      ),
    );
  }
}
