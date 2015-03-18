part of binary_repositories;

abstract class RepositoryProtocol {
  Future<bool> exists(Repository repository, String resource);

  Uri getUrl(Repository repository, String resource);

  Future<List<int>> read(Repository repository, String resource);

  Future write(Repository repository, String resource, List<int> bytes);
}
