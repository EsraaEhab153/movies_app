import 'package:flutter/material.dart';

import '../constants.dart';

class NewReleasedList extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const NewReleasedList({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  image: DecorationImage(
                      image: NetworkImage(
                          '${Constants.baseImage}${snapshot.data[index].posterPath}'),
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Image.asset(
                  'assets/images/icon_add_to_list.png',
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
              ),
            ]),
        separatorBuilder: (context, index) => SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
        itemCount: snapshot.data.length);
  }
}
//Todo:time of the movie
