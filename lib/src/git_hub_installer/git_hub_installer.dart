part of binary_repositories.git_hub_installer;

/**
 * Binary intstaller of resources from the "raw" GitHub.
 */
class GitHubInstaller {
  /**
   * Version constraint
   */
  final String constraint;

  /**
   * Package name
   */
  final String package;

  /**
   * Github repository
   */
  final String repository;

  /**
   * Github user
   */
  final String user;

  Function _decompress;

  Function _resource;

  VersioningProvider _versioning;

  /**
   * Creates [GitHubInstaller].
   *
   * Parameters:
   *   [String] user
   *   Github user
   *
   *   [String] repository
   *   Github repository
   *
   *   [String] package
   *   Package name
   *
   *   [Function] filepath
   *   Function that returns the relative path to resource
   *
   *   [String] constraint
   *   Version constraint
   *
   *   [Function] decompress
   *   Function that decompress the resource
   *
   *   [VersioningProvider] versioning
   *   Versioning provider
   */
  GitHubInstaller(this.user, this.repository, this.package, String resource(), this.constraint,
      {void decompress(String filepath), VersioningProvider versioning}) {
    if (constraint == null) {
      throw new ArgumentError.notNull("constraint");
    }

    if (resource == null) {
      throw new ArgumentError.notNull("resource");
    }

    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    if (user == null) {
      throw new ArgumentError.notNull("user");
    }

    if (versioning == null) {
      versioning = new SemanticVersioningProvider();
    }

    _decompress = decompress;
    _resource = resource;
    _versioning = versioning;
  }

  /**
   * Intalls the resource
   */
  Future<String> install() async {
    String resource = _resource();
    var pub = new PubBinaryRepository();
    var pm = new PackageManager();
    Uri url = await pm.resolve(pub, package, resource, constraint, _versioning);
    if (url == null) {
      return await update();
    }

    return url.toFilePath();
  }

  /**
   * Updates the resource
   */
  Future<String> update() async {
    String resource = _resource();
    var pub = new PubBinaryRepository();
    var provider = new FileBasedPackageProvider("packages", "packages.lst", "versions.lst");
    var github = new GitHubRawRepository("mezoni", "binaries", provider);
    var pm = new PackageManager();
    IntallationResult result = await pm.install(github, pub, package, _resource(), constraint, _versioning);
    Uri url = await pm.resolve(pub, package, resource, constraint, _versioning);
    if (url == null) {
      throw new StateError("Resource not available: $package($constraint)/$resource");
    }

    if (result.newVersion != null && _decompress != null) {
      var archive = url.toFilePath();
      try {
        _decompress(archive);
      } catch (e) {
        new File(archive).deleteSync();
        rethrow;
      }
    }

    return url.toFilePath();
  }
}
