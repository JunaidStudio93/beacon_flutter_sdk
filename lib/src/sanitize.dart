/// Name and value sanitization matching Beacon API constraints.
String sanitizeName(String name) {
  var result = name.trim().replaceAll(RegExp('[^a-zA-Z0-9_]'), '_');
  if (result.isEmpty || !RegExp('^[a-zA-Z]').hasMatch(result)) {
    result = 'e_$result';
  }
  return result.length > 40 ? result.substring(0, 40) : result;
}

String sanitizeValue(String? value) {
  if (value == null || value.isEmpty) return '';
  return value.length > 100 ? value.substring(0, 100) : value;
}
