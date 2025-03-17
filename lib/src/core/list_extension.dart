import 'package:aad_b2c_webview/aad_b2c_webview.dart';

extension ListExtension on List<HtmlParseEntity> {
  HtmlParseEntity? selectByID(String id) {
    if (isEmpty) return null;
    return firstWhereOrNull((e) => e.id == id);
  }

  HtmlParseEntity? selectByType(HtmlParseType type) {
    if (isEmpty) return null;
    return firstWhereOrNull((e) => e.type == type);
  }

  HtmlParseEntity? selectWithName(String name) {
    if (isEmpty) return null;
    return firstWhereOrNull((e) => e.name == name);
  }

  HtmlParseEntity? selectWithContent(String content) {
    if (isEmpty) return null;
    return firstWhereOrNull((e) => e.textContent == content);
  }

  HtmlParseEntity? selectWithPlaceholder(String placeholder) {
    if (isEmpty) return null;
    return firstWhereOrNull((e) => e.placeholder == placeholder);
  }
}

extension IterableExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
