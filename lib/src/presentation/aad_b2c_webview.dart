import 'package:aad_b2c_webview/src/services/client_authentication.dart';
import 'package:aad_b2c_webview/src/services/models/optional_param.dart';
import 'package:aad_b2c_webview/src/services/models/response_data.dart';
import 'package:aad_b2c_webview/src/services/models/token.dart';
import 'package:flutter/material.dart';
import 'package:pkce/pkce.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../constants.dart';

/// A widget that embeds the Azure AD B2C web view for authentication purposes.
class ADB2CEmbedWebView extends StatefulWidget {
  final String tenantBaseUrl;
  final String clientId;
  final String redirectUrl;
  final String userFlowName;
  final Function(BuildContext context)? onRedirect;
  final ValueChanged<Token> onAccessToken;
  final ValueChanged<Token> onIDToken;
  final ValueChanged<Token> onRefreshToken;
  final ValueChanged<Token>? onAnyTokenRetrieved;
  final List<String> scopes;
  final String responseType;
  final List<OptionalParam> optionalParameters;
  final Widget? loadingReplacement;
  final Color webViewBackgroundColor;

  const ADB2CEmbedWebView({
    super.key,
    // Required to work
    required this.tenantBaseUrl,
    required this.clientId,
    required this.redirectUrl,
    required this.userFlowName,
    required this.scopes,
    required this.onAccessToken,
    required this.onIDToken,
    required this.onRefreshToken,
    required this.optionalParameters,

    // Optionals
    this.onRedirect,
    this.onAnyTokenRetrieved,
    this.loadingReplacement,
    this.webViewBackgroundColor = const Color(0x00000000),

    // Optionals with default value
    this.responseType = Constants.defaultResponseType,
  });

  @override
  ADB2CEmbedWebViewState createState() => ADB2CEmbedWebViewState();
}

class ADB2CEmbedWebViewState extends State<ADB2CEmbedWebView> {
  final _key = UniqueKey();
  final PkcePair pkcePairInstance = PkcePair.generate();
  WebViewController? controller;
  late Function onRedirect;
  Widget? loadingReplacement;

  bool isLoading = true;
  bool showRedirect = false;

  @override
  void initState() {
    super.initState();
    onRedirect = widget.onRedirect ??
        () {
          Navigator.of(context).pop();
        };
    loadingReplacement = widget.loadingReplacement;

    final webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(widget.webViewBackgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });

            final Uri response = Uri.dataFromString(url);
            //Check that the user is past authentication and current URL is the redirect with the code.
            onPageFinishedTasks(url, response);
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          getUserFlowUrl(
            userFlow: "${widget.tenantBaseUrl}/${Constants.userFlowUrlEnding}",
          ),
        ),
      );
    if (webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (webViewController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    controller = webViewController;
  }

  @override
  void dispose() {
    super.dispose();
    controller = null;
  }

  /// Callback function for handling any token received.
  void onAnyTokenRecivedCallback(Token token) {
    if (widget.onAnyTokenRetrieved != null) {
      widget.onAnyTokenRetrieved!(token);
    }
  }

  /// Handles the callbacks for the received tokens.
  void handleTokenCallbacks({required AzureTokenResponse? tokensData}) {
    String? accessTokenValue = tokensData?.accessToken;
    String? idTokenValue = tokensData?.idToken;
    String? refreshTokenValue = tokensData?.refreshToken;

    if (accessTokenValue != null) {
      final Token token =
          Token(type: TokenType.accessToken, value: accessTokenValue);
      widget.onAccessToken(token);
      onAnyTokenRecivedCallback(token);
    }

    if (idTokenValue != null) {
      final token = Token(type: TokenType.idToken, value: idTokenValue);
      widget.onIDToken(token);
      onAnyTokenRecivedCallback(token);
    }

    if (refreshTokenValue != null) {
      final Token token = Token(
          type: TokenType.refreshToken,
          value: refreshTokenValue,
          expirationTime: tokensData?.refreshTokenExpireTime);
      widget.onRefreshToken(token);
      onAnyTokenRecivedCallback(token);
    }
  }

  // Performs the authorization code flow using the provided URL.
  Future<void> authorizationCodeFlow(url) async {
    String authCode = url.split("${Constants.authCode}=")[1];

    ClientAuthentication clientAuthentication =
        ClientAuthentication(pkcePair: pkcePairInstance);

    final AzureTokenResponse? tokensData =
        await clientAuthentication.getAllTokens(
      redirectUri: widget.redirectUrl,
      clientId: widget.clientId,
      authCode: authCode,
      providedScopes: (widget.scopes).isEmpty
          ? Constants.defaultScopes
          : createScopes(widget.scopes),
      userFlowName: widget.userFlowName,
      tenantBaseUrl: widget.tenantBaseUrl,
    );

    if (tokensData != null) {
      if (!mounted) return;
      // call redirect function
      handleTokenCallbacks(tokensData: tokensData);
      onRedirect(context);
    }
  }

  /// Executes tasks when the page finishes loading.
  dynamic onPageFinishedTasks(String url, Uri response) {
    if (response.path.contains(widget.redirectUrl)) {
      if (url.contains(Constants.idToken)) {
        //Navigate to the redirect route screen; check for mounted component
        if (!mounted) return;
        //call redirect function
        onRedirect(context);
      } else if (url.contains(Constants.accessToken)) {
        //Navigate to the redirect route screen; check for mounted component
        if (!mounted) return;
        //call redirect function
        onRedirect(context);
      } else if (url.contains(Constants.authCode)) {
        //Run authorization code flow and get access token.
        authorizationCodeFlow(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          WebViewWidget(
            key: _key,
            controller: controller!,
          ),
          Visibility(
              visible:
                  loadingReplacement != null && (isLoading || showRedirect),
              child: loadingReplacement ?? const SizedBox()),
          Visibility(
            visible: loadingReplacement == null && (isLoading || showRedirect),
            child: const Center(
              child: SizedBox(
                height: 250,
                width: 250,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),
          ),
          Visibility(
            visible: loadingReplacement == null && isLoading,
            child: const Positioned(
              child: Center(
                child: Text('Redirecting to Secure Login...'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constructs the user flow URL with optional parameters.
  String getUserFlowUrl({required String userFlow}) {
    List<String>? userFlowSplit = userFlow.split('?');
    //Check if the user added the full user flow or just till 'authorize'
    if (userFlowSplit.length == 1) {
      return concatUserFlow(userFlow);
    }
    return userFlow;
  }

  /// Creates a string representation of the scopes.
  String createScopes(List<String> scopeList) {
    return scopeList.join(' ');
  }

  /// Concatenates the user flow URL with additional parameters.
  String concatUserFlow(String url) {
    const idClientParam = '&client_id=';
    const nonceParam = '&nonce=defaultNonce&redirect_uri=';
    const scopeParam = '&scope=';
    const responseTypeParam = '&response_type=';
    const promptParam = '&prompt=login';
    const pageParam = '?p=';
    const codeChallengeMethod =
        '&code_challenge_method=${Constants.defaultCodeChallengeCode}';
    final codeChallenge = "&code_challenge=${pkcePairInstance.codeChallenge}";

    String newParameters = "";
    if (widget.optionalParameters.isNotEmpty) {
      for (OptionalParam param in widget.optionalParameters) {
        newParameters += "&${param.key}=${param.value}";
      }
    }

    return url +
        pageParam +
        widget.userFlowName +
        idClientParam +
        widget.clientId +
        nonceParam +
        widget.redirectUrl +
        scopeParam +
        createScopes(widget.scopes) +
        responseTypeParam +
        widget.responseType +
        promptParam +
        codeChallenge +
        codeChallengeMethod +
        newParameters;
  }
}
