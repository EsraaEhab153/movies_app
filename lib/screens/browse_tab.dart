import 'package:flutter/material.dart';
import 'package:movies_app/models/category.dart';
import 'package:movies_app/screens/browse_category_result.dart';

import '../api/api.dart';
import '../style/app_colors.dart';

class BrowseTab extends StatefulWidget {
  const BrowseTab({super.key});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  late Future<List<GenereCategory>> categories;

  @override
  void initState() {
    super.initState();
    categories = Api().getGenres();
  }

  @override
  Widget build(BuildContext context) {
    List<String> genreImage = [
      'assets/images/action.png',
      'assets/images/adventure.png',
      'assets/images/animation.png',
      'assets/images/comedy.png',
      'assets/images/crime.png',
      'assets/images/other_categories.png',
      'assets/images/other_categories.png',
      'assets/images/family.png',
      'assets/images/other_categories.png',
      'assets/images/crime.png',
      'assets/images/other_categories.png',
      'assets/images/other_categories.png',
      'assets/images/crime.png',
      'assets/images/other_categories.png',
      'assets/images/crime.png',
      'assets/images/other_categories.png',
      'assets/images/crime.png',
      'assets/images/other_categories.png',
      'assets/images/other_categories.png'
    ];
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
            top: MediaQuery.of(context).size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Browse Category',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            FutureBuilder(
              future: categories,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        mainAxisSpacing:
                            MediaQuery.of(context).size.height * 0.03,
                        crossAxisSpacing:
                            MediaQuery.of(context).size.width * 0.05,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            //print(snapshot.data?[index].id);
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BrowseCategoryResult(
                                    genreId: snapshot.data![index].id,
                                    genreName: snapshot.data![index].name,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(genreImage[index]),
                                  fit: BoxFit.fill,
                                  filterQuality: FilterQuality.high,
                                ),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Center(
                              child: Text(
                                snapshot.data![index].name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
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
        ),
      ),
    );
  }
}