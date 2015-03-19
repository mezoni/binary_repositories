part of binary_repositories;

/**
 * Binary platform resolver determines the running binary platform.
 */
class BinaryPlatformResolver {
  String _name;

  /**
   * Returns the name of the running binary platform in the form of the "ARCH/OS".
   */
  String get name {
    if (_name == null) {
      var arch = "unknown";
      var os = "unknown";
      switch (Platform.operatingSystem) {
        case "android":
        case "linux":
        case "windows":
        case "android":
          os = Platform.operatingSystem;
          break;
      }

      switch (SysInfo.processors.first.architecture) {
        case ProcessorArchitecture.X86:
          arch = "X86";
          break;
        case ProcessorArchitecture.X86_64:
          if (SysInfo.userSpaceBitness == 32) {
            arch = "X86";
          } else {
            arch = "X86_64";
          }

          break;
        default:
          break;
      }

      _name = "$arch/$os";
    }

    return _name;
  }
}
