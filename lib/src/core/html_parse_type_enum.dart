enum HtmlParseType {
  input,
  button,
  a,
  none;

  String get name => switch(this){
    HtmlParseType.input => 'input',
    HtmlParseType.button => 'button',
    HtmlParseType.a => 'a',
    HtmlParseType.none => 'none',
  };
}
