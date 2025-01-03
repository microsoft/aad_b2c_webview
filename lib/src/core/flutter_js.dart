import 'package:aad_b2c_webview/aad_b2c_webview.dart';

enum JsDocumentType { byClassName, querySelector, elementById }

class FlutterJsCustomAlert {
  final JsDocumentType type;
  final String code;
  final Map<String, String> conditions;

  FlutterJsCustomAlert({
    required this.type,
    required this.code,
    this.conditions = const <String, String>{},
  });
}

class FlutterJs {
  static String get jsFlutterAlertChannel => 'html_error_alert';

  static String get jsFlutterComponentChannel => 'html_components';

  static String get jsFunctionCheckComponentsOnScreen => '''
      (document.querySelector('${HtmlParseType.input.name}') !== null || 
       document.querySelector('${HtmlParseType.button.name}') !== null || 
       document.querySelector('${HtmlParseType.a.name}') !== null)
    ''';

  static String get jsFunctionToGetAlert => jsFunctionToGetCustomAlert(
        params: FlutterJsCustomAlert(
          type: JsDocumentType.querySelector,
          code: 'div.error.pageLevel p',
        ),
      );

  static String get jsFunctionToGetComponents => '''
(function() {
  function extractElements() {
    // Function to extract attributes from an element
    function getAttributes(element) {
      const attributes = {};
      for (let attr of element.attributes) {
        attributes[attr.name] = attr.value;
      }
      return attributes;
    }

    // Function to extract input, button, and link elements
    function extractInputsButtonsAndLinks() {
      const elements = document.querySelectorAll('${HtmlParseType.input.name}, ${HtmlParseType.button.name}, ${HtmlParseType.a.name}');
      const extractedElements = [];

      elements.forEach(element => {
        const attributes = getAttributes(element);
        extractedElements.push({
          name: element.name || '',
          id: element.id || '',
          placeholder: element.placeholder || '',
          type: element.tagName.toLowerCase(),
          textContent: element.textContent.trim() || '', // Capture the text of the element
          additionalAttributes: attributes
        });
      });

      return extractedElements;
    }

    // Send the data to Flutter
    function sendToFlutter(data) {
      if (window.html_components) {
        window.html_components.postMessage(JSON.stringify(data));
      } else {
        console.log('Flutter handler not found.');
      }
    }

    const extractedData = extractInputsButtonsAndLinks();
    sendToFlutter(extractedData);
  }

  // Start the extraction
  extractElements();
})();
''';

  static String jsFunctionToGetCustomAlert({
    required FlutterJsCustomAlert params,
  }) {
    switch (params.type) {
      case JsDocumentType.querySelector:
        return '''
          (function() {
            var targetNode = document.querySelector('${params.code}');
            if (!targetNode) return;
            
            var observer = new MutationObserver(function(mutationsList) {
              for (var mutation of mutationsList) {
                if (mutation.type === 'childList') {
                  if (mutation.target.innerText.trim() !== '') {
                    window.html_error_alert.postMessage(mutation.target.innerText.trim());
                  }
                }
              }
            });
            observer.observe(targetNode, { childList: true });
            
            if (targetNode.innerText.trim() !== '') {
              window.html_error_alert.postMessage(targetNode.innerText.trim());
            }
          })();
        ''';
      case JsDocumentType.elementById:
        return '''
          (function() {
            var targetNode = document.getElementById('${params.code}');
            if (!targetNode) return;
            
            var observer = new MutationObserver(function(mutationsList) {
              for (var mutation of mutationsList) {
                if (mutation.type === 'childList') {
                  if (mutation.target.innerText.trim() !== '') {
                    window.html_error_alert.postMessage(mutation.target.innerText.trim());
                  }
                }
              }
            });
            observer.observe(targetNode, { childList: true });
            
            if (targetNode.innerText.trim() !== '') {
              window.html_error_alert.postMessage(targetNode.innerText.trim());
            }
          })();
        ''';
      case JsDocumentType.byClassName:
        String conditionsCheck = params.conditions.entries.map((entry) {
          return 'targetNode.getAttribute("${entry.key}") === "${entry.value}"';
        }).join(' && ');
        return '''
      (function() {
        var targetNodes = document.querySelectorAll('${params.code}');
        if (!targetNodes || targetNodes.length === 0) return;
        
        targetNodes.forEach(function(targetNode) {
          if ($conditionsCheck) {
            var observer = new MutationObserver(function(mutationsList) {
              for (var mutation of mutationsList) {
                if (mutation.type === 'childList') {
                  if (targetNode.innerText.trim() !== '') {
                    window.html_error_alert.postMessage(targetNode.innerText.trim());
                  }
                }
              }
            });
            
            observer.observe(targetNode, { childList: true, subtree: true });
            if (targetNode.innerText.trim() !== '') {
              window.html_error_alert.postMessage(targetNode.innerText.trim());
            }
          }
        });
      })();
    ''';
    }
  }
}
