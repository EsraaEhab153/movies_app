class CustomMethods {
  static String timeFormat(int? runtime) {
    if (runtime == null) {
      return '0 h';
    }
    int hours = runtime ~/ 60;
    runtime ~/= 60;
    int min = runtime;
    return '$hours h $min min';
  }
}
