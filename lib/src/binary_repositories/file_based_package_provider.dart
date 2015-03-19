part of binary_repositories;

class FileBasedPackageProvider implements PackageProvider {
  String _packagesFile;

  String _packagesDirectory;

  String _versionsFile;

  FileBasedPackageProvider(String packagesDirectory, String packagesFile, String versionsFile) {
    _Utils.checkRelativePath(packagesFile, "packagesFile");
    _Utils.checkRelativePath(packagesDirectory, "packagesDirectory");
    _Utils.checkRelativePath(versionsFile, "versionsFile");
    _packagesFile = packagesFile;
    _packagesDirectory = packagesDirectory;
    _versionsFile = versionsFile;
  }

  String getPackageRoot(Repository repository, String package, String version) {
    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    if (package == null) {
      throw new ArgumentError.notNull("package");
    }

    if (package.isEmpty) {
      throw new ArgumentError("Package name should not be empty");
    }

    if (version == null) {
      throw new ArgumentError.notNull("version");
    }

    var root = _Utils.joinPath([_packagesDirectory, package, version]);
    return root;
  }

  Future<List<String>> listPackages(Repository repository) async {
    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    var packages = <String>[];
    if (!await repository.exists(_packagesFile)) {
      return packages;
    }

    List<int> bytes = await repository.read(_packagesFile);
    var string = new String.fromCharCodes(bytes);
    var lines = new LineSplitter().convert(string);
    for (var line in lines) {
      if (!line.isEmpty) {
        packages.add(line.trim());
      }
    }

    return packages;
  }

  Future<List<String>> listVersions(Repository repository, String package) async {
    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    if (package == null) {
      throw new ArgumentError.notNull("package");
    }

    if (package.isEmpty) {
      throw new ArgumentError("Package name should not be empty");
    }

    var path = _Utils.joinPath([_packagesDirectory, package, _versionsFile]);
    var versions = <String>[];
    if (!await repository.exists(path)) {
      return versions;
    }

    List<int> bytes = await repository.read(path);
    var string = new String.fromCharCodes(bytes);
    var lines = new LineSplitter().convert(string);
    for (var line in lines) {
      if (!line.isEmpty) {
        versions.add(line.trim());
      }
    }

    return versions;
  }
}
