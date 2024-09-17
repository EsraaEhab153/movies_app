import 'package:flutter/material.dart';
import 'package:movies_app/style/app_colors.dart';

import '../api/api.dart';
import '../constants.dart';
import '../models/movie.dart';
import 'movie_detailes_screen.dart';

class BrowseCategoryResult extends StatefulWidget {
  final int genreId;
  final String genreName;

  const BrowseCategoryResult(
      {super.key, required this.genreId, required this.genreName});

  @override
  State<BrowseCategoryResult> createState() => _BrowseCategoryResultState();
}

class _BrowseCategoryResultState extends State<BrowseCategoryResult> {
  late Future<List<Movie>> browseResult;

  @override
  void initState() {
    browseResult = Api().getBrowseResult(widget.genreId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: MyAppColors.primaryColor,
        title: Text(widget.genreName),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: browseResult,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: browseResult,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return (snapshot.data![index].posterPath.isNotEmpty)
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailsScreen(
                                                  movieId:
                                                      snapshot.data![index].id,
                                                  movieTitle: snapshot
                                                      .data![index].title),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Image.network(
                                            '${Constants.baseImage}${snapshot.data![index].posterPath}',
                                            fit: BoxFit.fill,
                                            filterQuality: FilterQuality.high,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.33,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Text(
                                                'Error loading image',
                                                style: TextStyle(
                                                  color: MyAppColors.goldColor,
                                                  fontSize: 7,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Text(
                                                  snapshot.data![index].title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                Text(
                                                  snapshot
                                                      .data![index].releaseDate,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                          color: Colors.grey),
                                                ),
                                                Text(
                                                  snapshot
                                                      .data![index].overview,
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
                          itemCount: snapshot.data!.length,
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
              ],
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
