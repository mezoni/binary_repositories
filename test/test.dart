import "package:binary_repositories/binary_repositories.dart";
import "package:unittest/unittest.dart";

main() async {
  var provider = new FileBasedPackageProvider("packages", "packages.lst", "versions.lst");
  var git = new GitHubRawRepository("mezoni", "binaries", provider);
  List packages = await git.listPackages();
  var package = "binary_interop.libffi";
  expect(packages.contains(package), true, reason: "Package not in list: $package");
}
