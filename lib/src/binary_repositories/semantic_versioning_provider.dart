part of binary_repositories;

class SemanticVersioningProvider implements VersioningProvider {
  bool allows(String version, String constraint) {
    if (version == null) {
      throw new ArgumentError.notNull("version");
    }

    if (constraint == null) {
      throw new ArgumentError.notNull("constraint");
    }

    return new VersionConstraint.parse(constraint).allows(new Version.parse(version));
  }

  int compare(String version1, String version2) {
    var a = new Version.parse(version1);
    var b = new Version.parse(version2);
    return a.compareTo(b);
  }
}
