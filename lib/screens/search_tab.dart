import 'package:flutter/material.dart';
import 'package:movies_app/style/app_colors.dart';

import '../api/api.dart';
import '../constants.dart';
import '../models/movie.dart';
import 'movie_detailes_screen.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController searchController = TextEditingController();
  Future<List<Movie>>? searchMovies;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void search(String query) {
    setState(() {
      searchMovies = Api().getSearchMovie(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.08,
        vertical: MediaQuery.of(context).size.width * 0.01,
      ),
      child: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: Colors.white30,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                fillColor: const Color(0xff514F4F),
                filled: true,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.018,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 0.5),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 0.5),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 0.5),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
              cursorColor: MyAppColors.goldColor,
              style: Theme.of(context).textTheme.bodyMedium,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  search(value);
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: searchMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MyAppColors.goldColor,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(child: Text('No movies found.'));
                    }
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return (snapshot.data![index].posterPath.isNotEmpty)
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailsScreen(
                                          movieId: snapshot.data![index].id,
                                          movieTitle:
                                              snapshot.data![index].title),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        '${Constants.baseImage}${snapshot.data![index].posterPath}',
                                        fit: BoxFit.fill,
                                        filterQuality: FilterQuality.high,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.33,
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                          MediaQuery.of(context).size.width *
                                              0.02),
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                              snapshot.data![index].releaseDate,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      color: Colors.grey),
                                            ),
                                            Text(
                                              snapshot.data![index].overview,
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
                    );
                  } else {
                    return Center(
                      child: Image.asset(
                        'assets/images/no_movie_icon.png',
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.13,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
