class MovieDetails {
  String title;
  String backDropPath;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;
  int id;
  int runTime;
  List<Genre> genres;

  MovieDetails(
      {required this.title,
      required this.backDropPath,
      required this.originalTitle,
      required this.overview,
      required this.posterPath,
      required this.releaseDate,
      required this.voteAverage,
      required this.id,
      required this.runTime,
      required this.genres});

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      title: json["title"],
      backDropPath: json["backdrop_path"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      releaseDate: json["release_date"],
      voteAverage: json["vote_average"],
      id: json["id"],
      runTime: json["runtime"],
      genres: (json['genres'] as List).map((i) => Genre.fromJson(i)).toList(),
    );
  }
}

class Genre {
  int id;
  String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}
