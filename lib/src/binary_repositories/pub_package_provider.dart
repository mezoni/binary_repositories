part of binary_repositories;

class PubPackageProvider implements PackageProvider {
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

    if (version.isEmpty) {
      throw new ArgumentError("Version should not be empty");
    }

    return "$package-$version";
  }

  Future<List<String>> listPackages(Repository repository) {
    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    var url = repository.baseUrl;
    var path = url.toFilePath();
    var packages = new Set<String>();
    var mask = _Utils.joinPath([path, "*"]);
    mask = mask.replaceAll("\\", "/");
    var files = FileUtils.glob(mask);
    for (var file in files) {
      if (FileUtils.testfile(file, "directory")) {
        var basename = lib_path.basename(file);
        var index = basename.indexOf("-");
        if (index > 0) {
          var package = basename.substring(0, index);
          packages.add(package);
        }
      }
    }

    return packages.toList();
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

    var path = repository.baseUrl.toFilePath();
    var versions = <String>[];
    var mask = _Utils.joinPath([path, "$package-*"]);
    mask = mask.replaceAll("\\", "/");
    var files = FileUtils.glob(mask);
    for (var file in files) {
      if (FileUtils.testfile(file, "directory")) {
        var basename = lib_path.basename(file);
        var index = basename.indexOf("-");
        if (index > 0) {
          var version = basename.substring(index + 1);
          versions.add(version);
        }
      }
    }

    return versions;
  }
}
