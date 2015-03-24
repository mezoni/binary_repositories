import "dart:io";
import "package:binary_repositories/binary_repositories.dart";
import "package:binary_repositories/git_hub_installer.dart";

main() async {
  var installer = new Installer();
  String file = await installer.install();
  print(file);
}

class Installer extends GitHubInstaller {
  static const String CONSTRAINT = ">=0.6.0<=0.7.0";

  static const String PACKAGE = "binary_interop.libffi";

  static const String REPOSITORY = "binaries";

  static const String USER = "user";

  Installer() : super(USER, REPOSITORY, PACKAGE, _resource, CONSTRAINT);

  static String _resource() {
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
    return "$platform/$file";
  }
}
