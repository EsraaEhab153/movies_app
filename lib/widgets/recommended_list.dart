import 'package:flutter/material.dart';
import 'package:movies_app/style/app_colors.dart';

import '../api/api.dart';
import '../constants.dart';
import '../custom_methods.dart';
import '../models/movie_details.dart';
import '../screens/movie_detailes_screen.dart';

class RecommendedList extends StatefulWidget {
  final AsyncSnapshot snapshot;

  const RecommendedList({super.key, required this.snapshot});

  @override
  State<RecommendedList> createState() => _RecommendedListState();
}

class _RecommendedListState extends State<RecommendedList> {
  late List<int?> movieRuntimes;

  @override
  void initState() {
    super.initState();
    movieRuntimes = List<int?>.filled(
        widget.snapshot.data.length, null); // Placeholder for runtimes
    addRuntimes();
  }

  Future<void> addRuntimes() async {
    for (int i = 0; i < widget.snapshot.data.length; i++) {
      final movieId = widget.snapshot.data[i].id;
      try {
        MovieDetails movieDetails = await Api().getMovieDetails(movieId);
        setState(() {
          movieRuntimes[i] = movieDetails.runTime;
        });
      } catch (e) {
        print('Error fetching runtime: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.213,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final runtime = movieRuntimes[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailsScreen(
                        movieId: widget.snapshot.data[index].id,
                        movieTitle: widget.snapshot.data[index].title),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.21,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: MyAppColors.cardListGrayColor),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(7.0),
                              topLeft: Radius.circular(7.0)),
                          child: Image.network(
                            '${Constants.baseImage}${widget.snapshot.data[index].posterPath}',
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high,
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.height * 0.14,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.014),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: MyAppColors.goldColor,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.009,
                                      ),
                                      Text(
                                        '${widget.snapshot.data[index].voteAverage}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${widget.snapshot.data[index].title}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      '${widget.snapshot.data[index].releaseDate.substring(0, 4)} R ${CustomMethods.timeFormat(runtime)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/icon_add_to_list.png',
                      width: MediaQuery.of(context).size.width * 0.06,
                      height: MediaQuery.of(context).size.height * 0.04,
                      alignment: Alignment.topLeft,
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
          itemCount: widget.snapshot.data.length),
    );
  }
}
