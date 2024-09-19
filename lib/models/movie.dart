class Movie {
  String title;
  String backDropPath;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;
  int id;

  Movie({
    required this.title,
    required this.backDropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.id,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"],
      backDropPath: json["backdrop_path"].toString(),
      originalTitle: json["original_title"].toString(),
      overview: json["overview"].toString(),
      posterPath: json["poster_path"].toString(),
      releaseDate: json["release_date"],
      voteAverage: json["vote_average"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "backdrop_path": backDropPath,
      "original_title": originalTitle,
      "overview": overview,
      "poster_path": posterPath,
      "release_date": releaseDate,
      "vote_average": voteAverage,
      "id": id,
    };
  }
}
