part of binary_repositories;

/**
 * Represent the result of the resource installation.
 */
class IntallationResult {
  /**
   * Returns the new version (which was installed).
   */
  final String newVersion;

  /**
   * Returns the old version (which was found before the installation).
   */
  final String oldVersion;

  /**
   * Creates the [IntallationResult].
   *
   * Parameters:
   *   [String] newVersion
   *   New version (which was installed).
   *
   *   [String] oldVersion
   *   Old version (which was found before the installation).
   */
  IntallationResult({this.newVersion, this.oldVersion});
}

/**
 * Package manager provides operations for installation and usage already installed resources.
 */
class PackageManager {
  /**
   * Installs the file from the [input] repository to the [output] repository from the specified package allowed by
   * version constraint and returns the information about installation.
   *
   * Parameters:
   *   [Repository] input
   *   Source repository (input)
   *
   *   [Repository] output
   *   Destination repository (output)
   *
   *   [String] package
   *   Package name
   *
   *   [String] filepath
   *   File path
   *
   *   [String] constraint
   *   Version constraint
   *
   *   [VersioningProvider] versioningProvider
   *   Versioning providert
   *
   *   [String] alias
   *   Package alias in the [input] repository
   */
  Future<IntallationResult> install(Repository input, Repository output, String package, String filepath,
      String constraint, VersioningProvider versioningProvider, {String alias}) async {
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
      path = _Utils.joinPath([path, filepath]);
      if (await input.exists(path)) {
        List<int> bytes = await input.read(path);
        path = await output.getPackageRoot(package, version);
        path = _Utils.joinPath([path, filepath]);
        await output.write(path, bytes);
        newVersion = version;
        break;
      }
    }

    return new IntallationResult(newVersion: newVersion, oldVersion: oldVersion);
  }

  /**
   * Determines the presence of specified file in the repository according the version constraint and returns an
   * absolute url of this file; otherwise null.
   *
   * Parameters:
   *   [Repository] repository
   *   Repository to check
   *
   *   [String] package
   *   Package name
   *
   *   [String] filepath
   *   File path
   *
   *   [String] constraint
   *   Version constraint
   *
   *   [VersioningProvider] versioningProvider
   *   Versioning providert
   */
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
        relativePath = _Utils.joinPath([relativePath, filepath]);
        if (await repository.exists(relativePath)) {
          return repository.getUrl(relativePath);
        }
      }
    }

    return null;
  }
}
