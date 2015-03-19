part of binary_repositories;

class _Utils {
  static String joinPath(List<String> parts) {
    var path = parts.join("/");
    return path;
  }

  static void checkRelativePath(String value, String name, {bool allowEmpty: false}) {
    if (value == null) {
      throw new ArgumentError.notNull(name);
    }

    if (value.isEmpty && allowEmpty == false) {
      throw new ArgumentError.value(value, name, "Should not be empty");
    }

    if (!lib_path.isRelative(value)) {
      throw new ArgumentError.value(value, name, "Should be relative path");
    }

    if (value.contains("\\")) {
      throw new ArgumentError.value(value, name, "Backslash character '\\' not allowed");
    }

    if (allowEmpty == null) {
      throw new ArgumentError.notNull("allowEmpty");
    }
  }
}
