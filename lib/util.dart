String getFirstLetter(String value) {
  if (value.isEmpty) return '#';
  var tag = value.substring(0, 1).toUpperCase();
  if (RegExp("[A-Z]").hasMatch(tag)) {
    return tag;
  } else {
    return "#";
  }
}
