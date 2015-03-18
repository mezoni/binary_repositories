part of binary_repositories;

abstract class PackageProvider {
  String getPackageRoot(Repository repository, String package, String version);

  Future<List<String>> listPackages(Repository repository);

  Future<List<String>> listVersions(Repository repository, String package);
}
