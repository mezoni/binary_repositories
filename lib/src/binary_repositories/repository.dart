part of binary_repositories;

abstract class Repository {
  Uri get baseUrl;

  PackageProvider get packageProvider;

  RepositoryProtocol get repositoryProtocol;

  Future<bool> exists(String resource);

  Uri getUrl(String resource);

  String getPackageRoot(String package, String version);

  Future<List<String>> listPackages();

  Future<List<String>> listVersions(String package);

  Future<List<int>> read(String resource);

  Future write(String resource, List<int> bytes);
}
