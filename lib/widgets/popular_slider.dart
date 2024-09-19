import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/constants.dart';
import 'package:movies_app/custom_methods.dart';
import 'package:movies_app/firestore_utilis.dart';
import 'package:movies_app/screens/movie_detailes_screen.dart';

import '../api/api.dart';
import '../models/movie_details.dart';

class PopularSlider extends StatefulWidget {
  final AsyncSnapshot snapshot;

  const PopularSlider({super.key, required this.snapshot});

  @override
  State<PopularSlider> createState() => _PopularSliderState();
}

class _PopularSliderState extends State<PopularSlider> {
  late List<int?> movieRuntimes;
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    movieRuntimes = List<int?>.filled(
        widget.snapshot.data.length, null); // list for storing runtimes
    isSelected = List.generate(widget.snapshot.data.length, (index) => false);
    addRuntimes();
    checkFavoriteMovies();
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

  Future<void> checkFavoriteMovies() async {
    var favoriteMoviesSnapshot =
        await FireStoreUtilies.getFavoriteMoviesCollection().get();
    var favoriteMovies =
        favoriteMoviesSnapshot.docs.map((doc) => doc.data().id).toSet();

    setState(() {
      for (int i = 0; i < widget.snapshot.data.length; i++) {
        if (favoriteMovies.contains(widget.snapshot.data[i].id)) {
          isSelected[i] = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: widget.snapshot.data.length,
      itemBuilder: (context, index, pageViewIndex) {
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
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(
                        '${Constants.baseImage}${widget.snapshot.data[index].posterPath}',
                      ),
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                    )),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.24,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.play_circle_fill_outlined,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.24,
                        top: MediaQuery.of(context).size.height * 0.016),
                    child: Column(
                      children: [
                        Text(
                          '${widget.snapshot.data[index].title}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.002,
                        ),
                        Text(
                          '${CustomMethods.getYear(widget.snapshot.data[index].releaseDate)} ${CustomMethods.timeFormat(runtime)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                          bottom: MediaQuery.of(context).size.height * 0.02),
                      width: MediaQuery.of(context).size.width * 0.31,
                      height: MediaQuery.of(context).size.height * 0.22,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * 0.01),
                          image: DecorationImage(
                              image: NetworkImage(
                                  '${Constants.baseImage}${widget.snapshot.data[index].posterPath}'),
                              fit: BoxFit.fill,
                              filterQuality: FilterQuality.high)),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.051,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isSelected[index] = !isSelected[index];
                            if (isSelected[index]) {
                              FireStoreUtilies.addedMovieToFireStore(
                                      widget.snapshot.data[index])
                                  .timeout(Duration(seconds: 2), onTimeout: () {
                                print('movie added successfully');
                              });
                            } else {
                              FireStoreUtilies.removeMovieFromFireStore(
                                      widget.snapshot.data[index].id)
                                  .timeout(Duration(seconds: 2), onTimeout: () {
                                print('movie removed successfully');
                              });
                            }
                            print(widget.snapshot.data[index].id);
                          });
                        },
                        child: Image.asset(
                          isSelected[index]
                              ? 'assets/images/added_to_watchlist_icon.png'
                              : 'assets/images/icon_add_to_list.png',
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width * 0.06,
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        autoPlayAnimationDuration: Duration(seconds: 1),
        height: MediaQuery.of(context).size.height * 0.33,
        autoPlay: true,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
      ),
    );
  }
}