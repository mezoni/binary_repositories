part of binary_repositories;

/**
 * Implementation of the [Repository] for the "raw GitHub" repository.
 */
class GitHubRawRepository extends RepositoryBase {
  /**
   * Github repository.
   */
  final String repository;

  /**
   * Github user (owner of the [repository]).
   */
  final String user;

  Uri _baseUrl;

  /**
   * Creates the [GitHubRawRepository].
   *
   * Parameters:
   *   [String] user
   *   Github user (owner of the [repository])
   *
   *   [String] repository
   *   Github repository
   *
   *   [PackageProvider] packageProvider
   *   Package provider
   */
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
