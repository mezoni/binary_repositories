part of binary_repositories;

abstract class RepositoryBase implements Repository {
  final RepositoryProtocol repositoryProtocol;

  final PackageProvider packageProvider;

  RepositoryBase(this.repositoryProtocol, this.packageProvider) {
    if (repositoryProtocol == null) {
      throw new ArgumentError.notNull("repositoryProtocol");
    }

    if (packageProvider == null) {
      throw new ArgumentError.notNull("packageProvider");
    }
  }

  Future<bool> exists(String resource) {
    return repositoryProtocol.exists(this, resource);
  }

  Uri getUrl(String resource) {
    return repositoryProtocol.getUrl(this, resource);
  }

  String getPackageRoot(String package, String version) {
    return packageProvider.getPackageRoot(this, package, version);
  }

  Future<List<String>> listPackages() {
    return packageProvider.listPackages(this);
  }

  Future<List<String>> listVersions(String package) {
    return packageProvider.listVersions(this, package);
  }

  Future<List<int>> read(String resource) {
    return repositoryProtocol.read(this, resource);
  }

  Future write(String resource, List<int> bytes) {
    return repositoryProtocol.write(this, resource, bytes);
  }
}
