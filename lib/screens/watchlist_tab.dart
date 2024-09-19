import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/firestore_utilis.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../style/app_colors.dart';
import 'movie_detailes_screen.dart';

class WatchListTab extends StatefulWidget {
  WatchListTab({super.key});

  @override
  State<WatchListTab> createState() => _WatchListTabState();
}

class _WatchListTabState extends State<WatchListTab> {
  List<Movie> favMovieList = [];

  @override
  Widget build(BuildContext context) {
    if (favMovieList.isEmpty) {
      getAllFavoriteMovies();
    }
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WatchList',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
                child: ListView.separated(
              itemBuilder: (context, index) {
                return (favMovieList[index].posterPath.isNotEmpty)
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsScreen(
                                  movieId: favMovieList[index].id,
                                  movieTitle: favMovieList[index].title),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Stack(
                                children: [
                                  Image.network(
                                    '${Constants.baseImage}${favMovieList[index].posterPath}',
                                    fit: BoxFit.fill,
                                    filterQuality: FilterQuality.high,
                                    width: MediaQuery.of(context).size.width *
                                        0.33,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Text(
                                        'Error loading image',
                                        style: TextStyle(
                                          color: MyAppColors.goldColor,
                                          fontSize: 7,
                                        ),
                                      );
                                    },
                                  ),
                                  InkWell(
                                    onTap: () {
                                      FireStoreUtilies.removeMovieFromFireStore(
                                              favMovieList[index].id)
                                          .timeout(Duration(seconds: 1),
                                              onTimeout: () {
                                        print('Movie removed successfully');

                                        setState(() {
                                          favMovieList.removeAt(index);
                                        });
                                      }).catchError((error) {
                                        print('Error removing movie: $error');
                                      });
                                    },
                                    child: Image.asset(
                                      'assets/images/added_to_watchlist_icon.png',
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width *
                                          0.06,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.02),
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      favMovieList[index].title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(
                                      favMovieList[index].releaseDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey),
                                    ),
                                    Text(
                                      favMovieList[index].overview,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Text(
                        'No photo',
                        style: TextStyle(
                          color: MyAppColors.goldColor,
                          fontSize: 7,
                        ),
                      );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: MyAppColors.grayColor,
                  thickness: 1,
                );
              },
              itemCount: favMovieList.length,
            ))
          ],
        ),
      ),
    );
  }

  void getAllFavoriteMovies() async {
    QuerySnapshot<Movie> querySnapshot =
        await FireStoreUtilies.getFavoriteMoviesCollection().get();

    favMovieList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    setState(() {});
  }
}
