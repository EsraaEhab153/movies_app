import 'package:flutter/material.dart';
import 'package:movies_app/api/api.dart';
import 'package:movies_app/style/app_colors.dart';
import 'package:movies_app/style/font_style.dart';
import 'package:movies_app/widgets/new_released_list.dart';
import 'package:movies_app/widgets/popular_slider.dart';
import 'package:movies_app/widgets/recommended_list.dart';

import '../models/movie.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> newReleasedMovies;
  late Future<List<Movie>> recommendedMovies;

  @override
  void initState() {
    super.initState();
    popularMovies = Api().getPopularMovies();
    newReleasedMovies = Api().getNewReleasedMovies();
    recommendedMovies = Api().getRecommendedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primaryColor,
      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.33,
                child: FutureBuilder(
                  future: popularMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      return PopularSlider(
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.027,
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.214,
                color: MyAppColors.listsColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'New Releases',
                      style: MyFontStyle.ListTitles,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.16,
                      child: FutureBuilder(
                        future: newReleasedMovies,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          } else if (snapshot.hasData) {
                            return NewReleasedList(snapshot: snapshot);
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: MyAppColors.goldColor,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
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
                      'Recommended',
                      style: MyFontStyle.ListTitles,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.016),
                    FutureBuilder(
                      future: recommendedMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return RecommendedList(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
