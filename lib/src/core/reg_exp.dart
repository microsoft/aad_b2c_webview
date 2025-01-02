class Check {
  static bool isLink(String text) {
    const urlPattern = r'^https:\/\/.*$';
    final regExp = RegExp(urlPattern);
    return regExp.hasMatch(text);
  }
}
