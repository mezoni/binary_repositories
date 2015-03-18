part of binary_repositories;

class _Utils {
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

    if (allowEmpty == null) {
      throw new ArgumentError.notNull("allowEmpty");
    }
  }
}
