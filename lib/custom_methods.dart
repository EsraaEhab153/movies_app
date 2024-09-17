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

  static String getYear(String date) {
    DateTime parsedDate = DateTime.parse(date);
    String year = parsedDate.year.toString();
    return year;
  }
}
