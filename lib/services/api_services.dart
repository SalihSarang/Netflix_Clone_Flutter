import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/movie_details_model.dart';
import 'package:netflix_clone/models/movie_recommendation_model.dart';
import 'package:netflix_clone/models/now_playing_model.dart';
import 'package:netflix_clone/models/popular_movie_model.dart';
import 'package:netflix_clone/models/search_model.dart';
import 'package:netflix_clone/models/tv_series_model.dart';
import 'package:netflix_clone/models/upcoming_models.dart';

const baseUrl = "https://api.themoviedb.org/3/";

late String endPoint;

class ApiServices {
  Future<UpcomingMovieModel> getUpcomingMovies() async {
    endPoint = "movie/upcoming";
    final url = '$baseUrl$endPoint';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      log('Success response upcoming movies: ${response.body}');
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    } else {
      log('Failed to upcoming movies: Status Code ${response.statusCode}');
      throw Exception(
        'Failed to load upcoming movies: Status Code ${response.statusCode}',
      );
    }
  }

  Future<NowPlayingModel> getNowPlaying() async {
    endPoint = "movie/now_playing";
    final url = '$baseUrl$endPoint';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      log('Success response now_playing: ${response.body}');
      return NowPlayingModel.fromJson(jsonDecode(response.body));
    } else {
      log('Failed to now_playing: Status Code ${response.statusCode}');
      throw Exception(
        'Failed to load now_playing: Status Code ${response.statusCode}',
      );
    }
  }

  Future<TvSeriesModel> getTvSeries() async {
    endPoint = "tv/top_rated";
    final url = '$baseUrl$endPoint';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        // 'Content-Type': 'application/json;charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      log('Success response top_rated: ${response.body}');
      return TvSeriesModel.fromJson(jsonDecode(response.body));
    } else {
      log('Failed to top_rated: Status Code ${response.statusCode}');
      throw Exception(
        'Failed to load top_rated: Status Code ${response.statusCode}',
      );
    }
  }

  Future<PopularMovieModel> getPopularMovie() async {
    endPoint = "movie/popular";
    final url = '$baseUrl$endPoint';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        // 'Content-Type': 'application/json;charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      log('Success response Popular Movie : ${response.body}');
      return PopularMovieModel.fromJson(jsonDecode(response.body));
    } else {
      log('Failed to Popular Movie : Status Code ${response.statusCode}');
      throw Exception(
        'Failed to load Popular Movie: Status Code ${response.statusCode}',
      );
    }
  }

  Future<SearchModel> getSearchedMovie(String searchText) async {
    endPoint = "search/movie?query=$searchText";
    final url = '$baseUrl$endPoint';

    log('Search Url : $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      log('Success response Search: ${response.body}');
      return SearchModel.fromJson(jsonDecode(response.body));
    } else {
      log('Failed to Search: Status Code ${response.statusCode}');
      throw Exception(
        'Failed to load Search : Status Code ${response.statusCode}',
      );
    }
  }

  Future<MovieDetailModel> getMovieDetails(int id) async {
    endPoint = "movie/$id";
    final url = '$baseUrl$endPoint';

    log('Movie Details Url : $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      log('Success response Movie Details: ${response.body}');
      return MovieDetailModel.fromJson(jsonDecode(response.body));
    } else {
      log('Failed to Movie Details : Status Code ${response.statusCode}');
      throw Exception(
        'Failed to load Movie Details : Status Code ${response.statusCode}',
      );
    }
  }

  Future<MovieRecommendationsModel> getMoviesRecommendationMovies(
    int id,
  ) async {
    endPoint = "movie/$id/recommendations";
    final url = '$baseUrl$endPoint';

    log('Recommendations Url: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );
    if (response.statusCode == 200) {
      log('Success response Recommendations: ${response.body}');
      return MovieRecommendationsModel.fromJson(jsonDecode(response.body));
    } else {
      log('Failed to Recommendations: Status Code ${response.statusCode}');
      throw Exception(
        'Failed to load Recommendations : Status Code ${response.statusCode}',
      );
    }
  }
}
