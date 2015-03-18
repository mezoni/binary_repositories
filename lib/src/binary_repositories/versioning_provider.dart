part of binary_repositories;

abstract class VersioningProvider {
  bool allows(String version, String constraint);

  int compare(String version1, String version2);
}
