part of binary_repositories;

/**
 * The versioning provider provides interface to the versioning system.
 */
abstract class VersioningProvider {
  /**
   * Returns true if the [constraint] allows specified [version]; otherwise false.
   *
   * Parameters:
   *   [String] version
   *   Version to check
   *
   *   [String] constraint
   *   Version constraint
   */
  bool allows(String version, String constraint);

  /**
   * Compares [version1] to [version2] using versioning comparison rules.
   *
   * Parameters:
   *   [String] version1
   *   First version to compare
   *
   *   [String] version2
   *   Second version to compare
   */
  int compare(String version1, String version2);
}
