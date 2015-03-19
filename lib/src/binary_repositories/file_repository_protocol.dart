part of binary_repositories;

class FileRepositoryProtocol implements RepositoryProtocol {
  Future<bool> exists(Repository repository, String resource) {
    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    _Utils.checkRelativePath(resource, "resource", allowEmpty: true);
    var url = _getUrl(repository, resource);
    var path = url.toFilePath();
    return new File(path).exists();
  }

  Uri getUrl(Repository repository, String resource) {
    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    _Utils.checkRelativePath(resource, "resource", allowEmpty: true);
    return _getUrl(repository, resource);
  }

  Future<List<int>> read(Repository repository, String resource) {
    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    _Utils.checkRelativePath(resource, "resource", allowEmpty: true);
    var url = _getUrl(repository, resource);
    var path = url.toFilePath();
    return new File(path).readAsBytes();
  }

  Future write(Repository repository, String resource, List<int> bytes) async {
    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    _Utils.checkRelativePath(resource, "resource", allowEmpty: true);
    if (bytes == null) {
      throw new ArgumentError.notNull("bytes");
    }

    var url = _getUrl(repository, resource);
    var path = url.toFilePath();
    var dirname = lib_path.dirname(path);
    if (dirname != ".") {
      new Directory(dirname).createSync(recursive: true);
    }

    await new File(path).writeAsBytes(bytes);
  }

  Uri _getUrl(Repository repository, String resource) {
    var baseUrl = repository.baseUrl;
    var scheme = baseUrl.scheme;
    if (scheme != "file") {
      throw new UnsupportedError("Unsupported scheme: $scheme");
    }

    var path = baseUrl.toFilePath();
    path = _Utils.joinPath([path, resource]);
    return new Uri.file(path);
  }
}
