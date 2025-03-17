import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/material.dart';

/// Builder function to create an success function. This function is called when
/// the web view redirect to app with tokens.
typedef WebViewSuccessFunction = Function(
  BuildContext context,
  TokenEntity? accessToken,
  TokenEntity? idToken,
  TokenEntity? refreshToken,
);

/// Builder function to create an success function. This function is called when
/// the web view catch any error.
typedef WebViewErrorFunction = Function(
  BuildContext context,
  String? error,
);

/// Builder function to create an error widget. This builder is called when
/// the web view failed loading.
typedef WebViewErrorWidgetBuilder = Widget Function(
  BuildContext context,
  String? error,
);

/// Builder function to get an webview controller. This builder is called when
/// the controller has created.
typedef WebViewControllerBuilder = void Function(
  BuildContext context,
  ActionController controller,
);

///  * [WidgetBuilder], which is similar but only takes a [BuildContext].
///  * [TransitionBuilder], which is similar but also takes a child.
typedef NullableWidgetsBuilder = Widget Function(
  BuildContext context,
  String? currentUrl,
  ActionController controller,
  List<HtmlParseEntity>? htmlItem,
);
