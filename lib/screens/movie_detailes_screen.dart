import 'package:flutter/material.dart';
import 'package:movies_app/custom_methods.dart';
import 'package:movies_app/models/movie_details.dart';
import 'package:movies_app/style/app_colors.dart';
import 'package:movies_app/widgets/more_like_this_list.dart';

import '../api/api.dart';
import '../constants.dart';
import '../models/movie.dart';
import '../style/font_style.dart';

class MovieDetailsScreen extends StatefulWidget {
  static const String routeName = 'movie_details_screen';
  final int movieId;
  final String movieTitle;

  const MovieDetailsScreen(
      {super.key, required this.movieId, required this.movieTitle});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<MovieDetails> movieDetail;
  late Future<List<Movie>> moreLikeThisMovies;

  @override
  void initState() {
    super.initState();
    movieDetail = Api().getMovieDetails(widget.movieId);
    moreLikeThisMovies = Api().getMoreLikeThis(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: MyAppColors.primaryColor,
        elevation: 0,
        title: Text(widget.movieTitle),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: movieDetail,
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data?.posterPath == null) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            final movie = snapshot.data;
            List<String> genreText =
                movie!.genres.map((genre) => genre.name).toList();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    '${Constants.baseImage}${movie.posterPath}',
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.24,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    margin: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.014),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 18),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.009,
                        ),
                        Text(
                          '${movie.releaseDate.substring(0, 4)}  ${CustomMethods.timeFormat(movie.runTime)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.022),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.31,
                              height: MediaQuery.of(context).size.height * 0.22,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        '${Constants.baseImage}${movie.posterPath}',
                                      ),
                                      fit: BoxFit.fill)),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/images/icon_add_to_list.png',
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width *
                                        0.06,
                                    height: MediaQuery.of(context).size.height *
                                        0.042,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.56,
                                    child: Wrap(
                                      spacing: 8.0, // Space between genre chips
                                      children: genreText.map((genre) {
                                        return Container(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.006),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xff514F4F),
                                                  width: 1)),
                                          child: Text(
                                            genre,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.height *
                                        0.16,
                                    child: SingleChildScrollView(
                                        child: Text(
                                      movie.overview,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    )),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: MyAppColors.goldColor,
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      Text('${movie.voteAverage}')
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.009,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.28,
                    color: MyAppColors.listsColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'More Like This',
                          style: MyFontStyle.ListTitles,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        FutureBuilder(
                          future: moreLikeThisMovies,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            } else if (snapshot.hasData) {
                              return MoreLikeThisList(
                                snapshot: snapshot,
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: MyAppColors.goldColor,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: MyAppColors.goldColor,
              ),
            );
          }
        },
      ),
    );
  }
}
