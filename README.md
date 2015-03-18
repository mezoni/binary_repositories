binary_repositories
=====

Binary repositories allows easy install individual binary files into local repository from the various kinds of external repositories. Also provides an easy access to installed files at runtime.

Version: 0.0.1

**Built-in features:**

- Access repositories through the `file` protocol
- Access repositories through the `http/https` protocol
- Access repositories through the custom protocol
- Access to the binary "pub" repository 
- Access to the "raw GitHub" repository
- File based package provider (eg. through the files `package.lst`, `versions.lst`)
- Package manager for installing and resolving binary files
- Package providers for list packages and their versions
- Repository protocols for reading and writing binary files
- Versioning through the `semantic versioning` 
- Versioning through the custom versioning

**Example of resolving an installed file**

```dart
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
  var path = await _resolve(package, file, constraint);
  if (path == null) {
    print("File not found: $package($constraint)/$file");
  } else {
    print("Resolved: $path");
  }
}

Future<String> _resolve(String package, String file, String constraint) async {
  var pub = new PubBinaryRepository();
  var versioning = new SemanticVersioningProvider();
  var pm = new PackageManager();
  return await pm.resolve(pub, package, file, constraint, versioning);
}

```

**Example of installing file from GitHub file based repository**

```dart
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

```
