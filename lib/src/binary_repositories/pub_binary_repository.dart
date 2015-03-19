part of binary_repositories;

class PubBinaryRepository extends RepositoryBase {
  Uri _baseUrl;

  PubBinaryRepository() : super(new FileRepositoryProtocol(), new PubPackageProvider()) {
    var cache = _getPubCache();
    var path = lib_path.join(cache, "binary").replaceAll("\\", "/");
    path = lib_path.normalize(path);
    _baseUrl = new Uri.file(path);
  }

  Uri get baseUrl => _baseUrl;

  String _getPubCache() {
    if (Platform.environment.containsKey('PUB_CACHE')) {
      return lib_path.normalize(Platform.environment['PUB_CACHE']).replaceAll("\\", "/");
    } else if (Platform.isWindows) {
      var path = Platform.environment['APPDATA'];
      return lib_path.join(path, 'Pub', 'Cache').replaceAll("\\", "/");
    } else {
      return '${Platform.environment['HOME']}/.pub-cache';
    }
  }
}
