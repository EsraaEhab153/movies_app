import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_app/constants.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/models/movie_details.dart';

class Api {
  static const _popularUrl =
      'https://api.themoviedb.org/3/movie/popular?api_key=${Constants.apiKey}';
  static const _newReleaseUrl =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.apiKey}';
  static const _recommendedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';
  static const _movieDetailsUrl = 'https://api.themoviedb.org/3/movie/';
  static const _moreLikeThisUrl = 'https://api.themoviedb.org/3/movie/';

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(_popularUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('SomeThing went wrong');
    }
  }

  Future<List<Movie>> getNewReleasedMovies() async {
    final response = await http.get(Uri.parse(_newReleaseUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('SomeThing went wrong');
    }
  }

  Future<List<Movie>> getRecommendedMovies() async {
    final response = await http.get(Uri.parse(_recommendedUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('SomeThing went wrong');
    }
  }

  Future<MovieDetails> getMovieDetails(int movieId) async {
    final response = await http.get(
        Uri.parse('$_movieDetailsUrl${movieId}?api_key=${Constants.apiKey}'));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return MovieDetails.fromJson(decodedData);
    } else {
      throw Exception('SomeThing went wrong');
    }
  }

  Future<List<Movie>> getMoreLikeThis(int movieId) async {
    final response = await http.get(Uri.parse(
        '$_moreLikeThisUrl${movieId}/similar?api_key=${Constants.apiKey}'));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('SomeThing went wrong');
    }
  }
}
