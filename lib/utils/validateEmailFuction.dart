// ignore_for_file: file_names

bool validateEmail(String value) {
  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)'
      r'|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
      r'\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+'
      r'[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}
