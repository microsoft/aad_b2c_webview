# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.56] - 2024-02-27
This changes the dependency from Dio to Dart's http packages for requests and adds user-agent field for sign-in purposes.

## [0.0.55] - 2024-02-16
This adds a new functionality, for onRedirect and onErrorOrCancel and adds a context argument.

## [0.0.54] - 2023-11-14
This adds a new functionality, onErrorOrCancel which is called when the redirect URL is hit with no tokens provided.

## [0.0.53] - 2023-11-06
Updated Readme with correct configurations for setup.

## [0.0.52] - 2023-10-24
Bug fixes for IOS.

## [0.0.51] - 2023-09-25
Bug fixes and performance improvements.

## [0.0.50] - 2023-08-30
Upgraded webview_flutter to latest version

## [0.0.49] - 2023-07-09
Added access token retrieval via widget.scopes and provided scopes

## [0.0.48] - 2023-07-07
Added official repository to pubspec.yaml

## [0.0.47] - 2023-07-03
Changes Made

Upgraded dependencies to latest versions

Provided example for the package

## [0.0.46] - 2023-06-05
Changes Made
Added the ability to include optional parameters in the AADLoginButton widget to customize the URL. The optionalParameters parameter now accepts a list of OptionalParam objects, where each object represents a parameter name and its corresponding value.

Updated the README.md file to include detailed instructions on how to utilize the optionalParameters parameter. An example was provided to demonstrate the addition of new parameters to the URL.

Created a new class, OptionalParam, to encapsulate the key-value pairs for the optional parameters.

Improved the concatUserFlow method to incorporate the optional parameters in the URL generation process.

Updated the UI implementation to utilize the Visibility widget. This change allows for the removal of unnecessary Stack widgets, resulting in a cleaner and more efficient UI structure.

These changes enhance the flexibility and customization options of the AADLoginButton widget, while also improving code organization, readability, and user experience.

Thanks to [Baxi19](https://github.com/Baxi19) for his contributions to this release.

## [0.0.45] - 2023-04-26

Added new model class that map responses from Azure: AzureTokenResponse

Added a new model class that tracks down in a better way a token, instead of plan text and Obj called: Token, wich really comes handy when handling refresh tokens due to users need to know not only the token but also its expiration date.

Fixed refresh tokens not being retrieved on AADLoginButton and ADB2CEmbedWebView onRefreshToken callback

Added a new callback method called: onAnyTokenRetrieved, this method could be used instead of all the others

ClientAuthentication class is fixed now and both methods found on it: getAllTokens and refreshTokens work now was expected.

## [0.0.44] - 2023-02-28

We're super excited to announce `0.0.44` of `aad_b2c_webview`!

This major release fully focuses on adding robust functionality to the integration of Azure AD & embedded web views.

This is the second big release by two of our `standard` co-maintainers [Mohana Bhattacharya](https://github.com/mohanajuhi166) & [Chimdike Nnacheta](https://github.com/sleeknoah). Buy them a cake if you run into them, thanks for getting this release out!

### Major changes

- Created a login/sign up button, that can be easily integrated and customized for the mobile application
- Added ValueChanged callback to the login button, that returns the user's id token

### Changed features

- Updated login button implementation and fixes to ReadMe file
- Created a login button to login into Azure AD B2C. This can be used in any flutter app to login into Azure AD B2C
- Removed unwanted dependencies
- Added ValueChanged to give users more control of accessTokens and redirect process
- Other small fixes

## [0.0.42] - 2023-02-06

- Updated package to use PKCE flow for authentication
- Updated flutter secure storage's usage and secure access for token
- Updated redirect methods to use PKCE flow
- Updated README.md
- Updated CHANGELOG.md
- Updated pubspec.yaml

