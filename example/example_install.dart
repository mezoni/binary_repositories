import "dart:io";
import "dart:async";
import "package:binary_repositories/binary_repositories.dart";

main() async {
  String file;
  switch (Platform.operatingSystem) {
    case "linux":
      file = "libffi.so.6";
      break;
    case "macos":
      file = "libffi.6.dylib";
      break;
    case "windows":
      file = "libffi-6.dll";
      break;
    default:
      throw new UnsupportedError("Unsupported operating system: ${Platform.operatingSystem}");
  }

  var platform = new BinaryPlatformResolver().name;
  file = "$platform/$file";
  var package = "binary_interop.libffi";
  var constraint = ">=0.6.0<0.7.0";
  IntallationResult result = await _install(package, file, constraint);
  print("IntallationResult: $package($constraint)/$file");
  print("New version: ${result.newVersion}");
  print("Old version: ${result.oldVersion}");
}

Future<String> _install(String package, String file, String constraint) async {
  var pub = new PubBinaryRepository();
  var provider = new FileBasedPackageProvider("packages", "packages.lst", "versions.lst");
  var github = new GitHubRawRepository("mezoni", "binaries", provider);
  var versioning = new SemanticVersioningProvider();
  var pm = new PackageManager();
  return await pm.install(github, pub, package, file, constraint, versioning);
}
