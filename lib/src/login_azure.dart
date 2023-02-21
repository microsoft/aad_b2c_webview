import 'package:aad_b2c_webview/src/aad_b2c_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AADLoginButton extends StatefulWidget {
  final String url;
  final String clientId;
  final String redirectUrl;
  final String appRedirectRoute;
  final Function(BuildContext context)? onRedirect;
  final BuildContext? context;
  final ValueChanged<String>? onAccessToken;
  final ValueChanged<String>? onIDToken;
  final ValueChanged<String>? onRefreshToken;
  const AADLoginButton({
    super.key,
    required this.url,
    required this.clientId,
    required this.redirectUrl,
    required this.appRedirectRoute,
    this.onRedirect,
    required this.context,
    this.onAccessToken,
    this.onIDToken,
    this.onRefreshToken,
  });
  // : assert(url != ''),
  //   assert(clientId != ''),
  //   assert(redirectUrl != ''),
  //   assert(appRedirectRoute != '');

  @override
  State<AADLoginButton> createState() => _AADLoginButtonState();
}

class _AADLoginButtonState extends State<AADLoginButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(widget.context ?? context).push(
          MaterialPageRoute(
            builder: (context) {
              return ADB2CEmbedWebView(
                url: widget.url,
                clientId: widget.clientId,
                redirectUrl: widget.redirectUrl,
                appRedirectRoute: widget.appRedirectRoute,
                onRedirect: widget.onRedirect,
                onAccessToken: (accessToken) {
                  widget.onAccessToken!(accessToken);
                },
                onIDToken: (idToken) {
                  widget.onIDToken!(idToken);
                },
                onRefreshToken: (refreshToken) {
                  widget.onRefreshToken!(refreshToken);
                },
              );
            },
          ),
        );
      },
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(
          8.0,
        ),
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 36.0,
            ),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                Text(
                  'Login with Azure AD',
                  style: GoogleFonts.nunito(),
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  width: 20.0,
                ),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: SvgPicture.asset(
                    'assets/windows-windows-svgrepo-com.svg',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
