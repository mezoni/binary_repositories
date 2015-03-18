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
