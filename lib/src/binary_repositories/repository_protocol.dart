part of binary_repositories;

/**
 * The protocol provides access to the resources of the repository.
 */
abstract class RepositoryProtocol {
  /**
   * Returns true if the specified resourse exists in the repository; otherwise false.
   *
   * Parameters:
   *   [Repository] repository
   *   Repository
   *
   *   [String] resource
   *   Relative path to the resource in the repository
   */
  Future<bool> exists(Repository repository, String resource);

  /**
   * Return an absolute url of the specified resourse in the repository.
   *
   * Parameters:
   *   [Repository] repository
   *   Repository
   *
   *   [String] resource
   *   Relative path to the resource in the repository
   */
  Uri getUrl(Repository repository, String resource);

  /**
   * Reads the bytes from the specified resource in the repository.
   *
   * Parameters:
   *   [Repository] repository
   *   Repository
   *
   *   [String] resource
   *   Relative path to the resource in the repository
   */
  Future<List<int>> read(Repository repository, String resource);

  /**
   * Writes the bytes to the specified resource in the repository.
   *
   * Parameters:
   *   [Repository] repository
   *   Repository
   *
   *   [String] resource
   *   Relative path to the resource in the repository
   *
   *   [List<[int]>] bytes
   *   List of the bytes to write
   */
  Future write(Repository repository, String resource, List<int> bytes);
}
