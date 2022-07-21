import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie_app/src/movies/now_playing_movie_list_model.dart';
import '../settings/settings_view.dart';
import '../widgets/movie_card_widget.dart';
import 'movie_item_details_view.dart';
import 'package:http/http.dart' as http;

class MovieListView extends StatefulWidget {
  const MovieListView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  State<MovieListView> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfPostsPerRequest = 10;
  late List<Results> _movies;
  late NowPlayingMovie nowPlayingMovie;
  final int _nextPageTrigger = 3;

  @override
  void initState() {
    super.initState();
    _pageNumber = 1;
    _movies = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/movie/now_playing?page=$_pageNumber&api_key=2b4e50df8fd06e2b35de23b97f3546a1"));

      nowPlayingMovie = NowPlayingMovie.fromJson(jsonDecode(response.body));

      setState(() {
        _isLastPage =
            nowPlayingMovie.results!.length < _numberOfPostsPerRequest;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        _movies.addAll(nowPlayingMovie.results!);
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Widget errorDialog({required double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred when fetching the movies.',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = false;
                  fetchData();
                });
              },
              child: const Text(
                "Retry",
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Now Showing"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: buildPostsView(),
    );
  }

  Widget buildPostsView() {
    if (_movies.isEmpty) {
      if (_loading) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(child: errorDialog(size: 20));
      }
    }
    return ListView.builder(
        itemCount: _movies.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == _movies.length - _nextPageTrigger) {
            fetchData();
          }
          if (index == _movies.length) {
            if (_error) {
              return Center(child: errorDialog(size: 15));
            } else {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ));
            }
          }
          final Results movie = _movies[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.restorablePushNamed(
                    context, MovieDetailsView.routeName,
                    arguments: movie.id!);
              },
              child: movieCard(
                  movieTitle: movie.title!,
                  index: index,
                  imagePath:
                      'https://image.tmdb.org/t/p/original${movie.posterPath}'),
            ),
          );
        });
  }

  Future<NowPlayingMovie> fetchMovie(int page) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=2b4e50df8fd06e2b35de23b97f3546a1&page=${page}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return NowPlayingMovie.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load movie');
    }
  }
}
