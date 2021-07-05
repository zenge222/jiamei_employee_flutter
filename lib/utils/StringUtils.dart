class StringUtils {
  static bool isEmpty(String s) {
    if (s != null && s.trim().length > 0 && s != "null") {
      return false;
    }
    return true;
  }
}
