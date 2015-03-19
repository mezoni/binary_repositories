part of binary_repositories;

class HttpRepositoryProtocol implements RepositoryProtocol {
  Future<bool> exists(Repository repository, String resource) async {
    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    _Utils.checkRelativePath(resource, "resource", allowEmpty: true);
    var url = _getUrl(repository, resource);
    var client = new HttpClient();
    HttpClientRequest request = await client.headUrl(url);
    HttpClientResponse response = await request.close();
    var exists = response.statusCode == HttpStatus.OK;
    await client.close();
    return exists;
  }

  Uri getUrl(Repository repository, String resource) {
    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    _Utils.checkRelativePath(resource, "resource", allowEmpty: true);
    return getUrl(repository, resource);
  }

  Future<List<int>> read(Repository repository, String resource) async {
    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    _Utils.checkRelativePath(resource, "resource", allowEmpty: true);
    var url = _getUrl(repository, resource);
    var client = new HttpClient();
    HttpClientRequest request = await client.getUrl(url);
    HttpClientResponse response = await request.close();
    if (response.statusCode != HttpStatus.OK) {
      throw new HttpException("Resource not found", uri: url);
    }

    var bytes = <int>[];
    await for (List<int> part in response) {
      bytes.addAll(part);
    }

    await client.close();
    return bytes;
  }

  Future write(Repository repository, String resource, List<int> bytes) {
    throw new UnsupportedError("write()");
  }

  Uri _getUrl(Repository repository, String resource) {
    var baseUrl = repository.baseUrl;
    var scheme = baseUrl.scheme;
    var path = baseUrl.toString();
    path = _Utils.joinPath([path, resource]);
    switch (scheme) {
      case "http":
      case "https":
        return Uri.parse(path);
      default:
        throw new UnsupportedError("Unsupported scheme: $scheme");
    }
  }
}
