/// Class represents an optional parameter for the Azure AD B2C user flow.
/// for sending optional parameters in a link.

class OptionalParam {
  /// The name of the optional parameter.
  final String key;

  /// The value of the optional parameter.
  final String value;

  /// Creates a new instance of [OptionalParam] 
  /// with the given [key] and [value].
  OptionalParam({
    required this.key,
    required this.value,
  });
}
