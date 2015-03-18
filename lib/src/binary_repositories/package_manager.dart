part of binary_repositories;

class IntallationResult {
  final String newVersion;

  final String oldVersion;

  IntallationResult({this.newVersion, this.oldVersion});
}

class PackageManager {
  Future<IntallationResult> install(Repository input, Repository output, String package, String filepath, String constraint,
      VersioningProvider versioningProvider, {String alias}) async {
    if (input == null) {
      throw new ArgumentError.notNull("input");
    }

    if (output == null) {
      throw new ArgumentError.notNull("output");
    }

    if (filepath == null) {
      throw new ArgumentError.notNull("filename");
    }

    if (filepath.isEmpty) {
      throw new ArgumentError("File name should not be empty");
    }

    if (alias == null) {
      alias = package;
    } else if (alias.isEmpty) {
      throw new ArgumentError("Alias should not be empty");
    }

    List<String> versions = await output.listVersions(package);
    versions.sort((a, b) => versioningProvider.compare(b, a));
    String newVersion;
    String oldVersion;
    for (var version in versions) {
      if (versioningProvider.allows(version, constraint)) {
        var path = output.getPackageRoot(package, version);
        path = "$path/$filepath";
        if (await output.exists(path)) {
          oldVersion = version;
          break;
        }
      }
    }

    versions = <String>[];
    for (String version in await input.listVersions(package)) {
      if (versioningProvider.allows(version, constraint)) {
        if (oldVersion != null) {
          if (version.compareTo(oldVersion) > 0) {
            versions.add(version);
          }
        } else {
          versions.add(version);
        }
      }
    }

    versions.sort((a, b) => versioningProvider.compare(b, a));
    for (var version in versions) {
      String path = await input.getPackageRoot(package, version);
      path = lib_path.join(path, filepath);
      if (await input.exists(path)) {
        List<int> bytes = await input.read(path);
        path = await output.getPackageRoot(package, version);
        path = lib_path.join(path, filepath);
        await output.write(path, bytes);
        newVersion = version;
        break;
      }
    }

    return new IntallationResult(newVersion: newVersion, oldVersion: oldVersion);
  }

  Future<Uri> resolve(Repository repository, String package, String filepath, String constraint,
      VersioningProvider versioningProvider) async {
    if (package == null) {
      throw new ArgumentError.notNull("package");
    }

    if (filepath == null) {
      throw new ArgumentError.notNull("filepath");
    }

    if (filepath.isEmpty) {
      throw new ArgumentError("Filepath should not be empty");
    }

    if (constraint == null) {
      throw new ArgumentError.notNull("constraint");
    }

    List<String> versions = await repository.listVersions(package);
    versions.sort((a, b) => versioningProvider.compare(b, a));
    for (var version in versions) {
      if (versioningProvider.allows(version, constraint)) {
        String relativePath = await repository.getPackageRoot(package, version);
        relativePath = lib_path.join(relativePath, filepath);
        if (await repository.exists(relativePath)) {
          return repository.getUrl(relativePath);
        }
      }
    }

    return null;
  }
}