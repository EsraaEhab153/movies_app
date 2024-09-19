import 'package:flutter/material.dart';

import '../constants.dart';
import '../firestore_utilis.dart';
import '../screens/movie_detailes_screen.dart';

class NewReleasedList extends StatefulWidget {
  final AsyncSnapshot snapshot;

  const NewReleasedList({super.key, required this.snapshot});

  @override
  State<NewReleasedList> createState() => _NewReleasedListState();
}

class _NewReleasedListState extends State<NewReleasedList> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = List.generate(widget.snapshot.data.length, (index) => false);
    checkFavoriteMovies();
  }

  Future<void> checkFavoriteMovies() async {
    List<int> movieIds = widget.snapshot.data.map((movie) => movie.id).toList();

    List<bool> favorites = await FireStoreUtilies.checkFavoriteMovies(movieIds);

    setState(() {
      isSelected = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => InkWell(
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
              child: Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    image: DecorationImage(
                        image: NetworkImage(
                            '${Constants.baseImage}${widget.snapshot.data[index].posterPath}'),
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isSelected[index] = !isSelected[index];
                      if (isSelected[index]) {
                        FireStoreUtilies.addedMovieToFireStore(
                                widget.snapshot.data[index])
                            .timeout(const Duration(seconds: 2), onTimeout: () {
                          print('movie added successfully');
                        });
                      } else {
                        FireStoreUtilies.removeMovieFromFireStore(
                                widget.snapshot.data[index].id)
                            .timeout(const Duration(seconds: 2), onTimeout: () {
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
              ]),
            ),
        separatorBuilder: (context, index) => SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
        itemCount: widget.snapshot.data.length);
  }
}
