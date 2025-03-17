import 'package:aad_b2c_webview/aad_b2c_webview.dart';

extension StringExtension on String {
  HtmlParseType convertToType() {
    switch (this) {
      case 'input':
        return HtmlParseType.input;
      case 'button':
        return HtmlParseType.button;
      case 'a':
        return HtmlParseType.a;
      default:
        return HtmlParseType.none;
    }
  }

  String encodeComponent() => Uri.encodeComponent(this);
}
