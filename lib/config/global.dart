class GlobalVar {
  static final GlobalVar _instance = GlobalVar._internal();
  factory GlobalVar() => _instance;
  GlobalVar._internal();

  static String version = "v0.0.1";
}
