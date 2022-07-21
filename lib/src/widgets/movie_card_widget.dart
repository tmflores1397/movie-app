import 'package:flutter/material.dart';

class movieCard extends StatelessWidget {
  final String movieTitle;
  final int index;
  final String? imagePath;
  const movieCard(
      {required this.movieTitle, required this.index, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: this.index % 2 == 0
          ? Colors.lightBlueAccent.withOpacity(0.4)
          : Colors.white.withOpacity(0.4),
      elevation: 5,
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTile(
          leading: Container(
            child: imagePath != null
                ? Image.network(imagePath!)
                : Image.asset('assets/images/movie_icon.png'),
          ),
          subtitle: Center(
            child: Text(movieTitle, style: TextStyle(fontSize: 18.0)),
          ),
        ),
      ]),
    );
  }
}
