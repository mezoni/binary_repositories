part of binary_repositories;

/**
 * Repository provider for data manipulation in the repository.
 */
abstract class Repository {
  /**
   * Returns an absolute base url of the repository.
   */
  Uri get baseUrl;

  /**
   * Returns the package provider associated with the repository.
   */
  PackageProvider get packageProvider;

  /**
   * Returns the package provider associated with the repository.
   */
  RepositoryProtocol get repositoryProtocol;

  /**
   * Returns true if the specified resourse exists in the repository; otherwise false.
   *
   * Parameters:
   *   [String] resource
   *   Relative path to the resource in the repository
   */
  Future<bool> exists(String resource);

  /**
   * Return an absolute url of the specified resourse in the repository.
   *
   * Parameters:
   *   [String] resource
   *   Relative path to the resource in the repository
   */
  Uri getUrl(String resource);

  /**
   * Returns a relative path of the package root with specified version in the repository.
   *
   * Parameters:
   *   [String] package
   *   Package name
   *
   *   [String] version
   *   Package version
   */
  String getPackageRoot(String package, String version);

  /**
   * Returns the list of the packages in the repository.
   */
  Future<List<String>> listPackages();

  /**
   * Returns the list of versions of the specified package in the repository.
   *
   * Parameters:
   *   [String] package
   *   Package name
   */
  Future<List<String>> listVersions(String package);

  /**
   * Reads the bytes from the specified resource in the repository.
   *
   * Parameters:
   *   [String] resource
   *   Relative path to the resource in the repository
   */
  Future<List<int>> read(String resource);

  /**
   * Writes the bytes to the specified resource in the repository.
   *
   * Parameters:
   *   [String] resource
   *   Relative path to the resource in the repository
   *
   *   [List<[int]>] bytes
   *   List of the bytes to write
   */
  Future write(String resource, List<int> bytes);
}
