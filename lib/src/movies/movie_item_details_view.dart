import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/movie_details_card_widget.dart';
import 'movie_model.dart';
import 'package:http/http.dart' as http;

/// Displays detailed information about a SampleItem.
class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({Key? key}) : super(key: key);

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    final movieId = ModalRoute.of(context)?.settings.arguments as int?;
    late Future<MovieDetailsObject> futureMovieDetails;
    debugPrint(movieId.toString());
    if (movieId != null) {
      futureMovieDetails = fetchMovieDetails(movieId);
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Movie Details'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: FutureBuilder<MovieDetailsObject>(
              future: futureMovieDetails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      child: movieDetailsCard(
                    movieTitle: snapshot.data!.title!,
                    imagePath:
                        'https://image.tmdb.org/t/p/w500${snapshot.data!.posterPath!}',
                    movieGenre: snapshot.data!.genres!,
                    releaseDate: snapshot.data!.releaseDate!,
                    overview: snapshot.data!.overview!,
                    homepage: snapshot.data!.homepage!,
                  ));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ));
  }

  Future<MovieDetailsObject> fetchMovieDetails(int movieId) async {
    debugPrint("Movie Id");
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/${movieId}?api_key=2b4e50df8fd06e2b35de23b97f3546a1');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return MovieDetailsObject.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load movie');
    }
  }
}
