part of binary_repositories;

class GitHubRawRepository extends RepositoryBase {
  final String repository;

  final String user;

  Uri _baseUrl;

  GitHubRawRepository(this.user, this.repository, PackageProvider packageProvider)
      : super(new HttpRepositoryProtocol(), packageProvider) {
    if (user == null) {
      throw new ArgumentError.notNull("user");
    }

    if (user.isEmpty) {
      throw new ArgumentError("User name should not be empty");
    }

    if (repository == null) {
      throw new ArgumentError.notNull("repository");
    }

    if (repository.isEmpty) {
      throw new ArgumentError("Repository name should not be empty");
    }

    var path = _Utils.joinPath([user, repository, "master"]);
    _baseUrl = new Uri.https("raw.githubusercontent.com", path);
  }

  Uri get baseUrl => _baseUrl;
}
