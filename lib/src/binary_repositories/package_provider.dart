part of binary_repositories;

/**
 * Package provider provides the information about the available packages.
 */
abstract class PackageProvider {
  /**
   * Returns a relative path of the package root with specified version in the repository.
   *
   * Parameters:
   *   [Repository] repository
   *   Repository
   *
   *   [String] package
   *   Package name
   *
   *   [String] version
   *   Package version
   */
  String getPackageRoot(Repository repository, String package, String version);

  /**
   * Returns the list of the packages in the repository.
   *
   * Parameters:
   *   [Repository] repository
   *   Repository
   */
  Future<List<String>> listPackages(Repository repository);

  /**
   * Returns the list of versions of the specified package in the repository.
   *
   * Parameters:
   *   [Repository] repository
   *   Repository
   *
   *   [String] package
   *   Package name
   */
  Future<List<String>> listVersions(Repository repository, String package);
}
