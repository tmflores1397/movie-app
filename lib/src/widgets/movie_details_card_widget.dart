import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/src/movies/movie_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class movieDetailsCard extends StatelessWidget {
  final String movieTitle;
  final List<Genres> movieGenre;
  final String imagePath;
  final String releaseDate;
  final String overview;
  final String homepage;

  const movieDetailsCard(
      {required this.movieTitle,
      required this.imagePath,
      required this.movieGenre,
      required this.releaseDate,
      required this.overview,
      required this.homepage});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            movieTitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
          ),
        ),
        SizedBox(
          height: 30,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: movieGenre.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Text(movieGenre[index].name! + ' ');
            },
          ),
        ),
        Text(releaseDate),
        RichText(
          text: TextSpan(
            text: homepage,
            style: new TextStyle(color: Colors.blue),
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                launchUrlString(homepage);
              },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Image.network(
              imagePath,
              width: 500.0,
              height: 500.0,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(overview),
        )
      ]),
    );
  }
}
