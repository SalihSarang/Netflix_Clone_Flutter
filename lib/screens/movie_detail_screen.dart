import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/movie_details_model.dart';
import 'package:netflix_clone/models/movie_recommendation_model.dart';
import 'package:netflix_clone/services/api_services.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  ApiServices apiServices = ApiServices();
  late Future<MovieDetailModel> movieDetail;
  late Future<MovieRecommendationsModel> movieRecommendation;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  fetchInitialData() {
    movieDetail = apiServices.getMovieDetails(widget.movieId);
    movieRecommendation = apiServices.getMoviesRecommendationMovies(
      widget.movieId,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.movieId);
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: movieDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final movie = snapshot.data;
              String genreText = movie!.genres
                  .map((genre) => genre.name)
                  .join(',');
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              '$imageUrl${movie!.posterPath}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 10,
                      top: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),

                        Row(
                          children: [
                            Text(
                              movie.releaseDate.year.toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(width: 20),
                            Text(
                              genreText,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          movie.overview,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 17, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  FutureBuilder(
                    future: movieRecommendation,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final moviesRecommended = snapshot.data;
                        return moviesRecommended!.results.isEmpty
                            ? SizedBox()
                            : Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('More Like This'),

                                  GridView.builder(
                                    itemCount: moviesRecommended.results.length,
                                    shrinkWrap: true,

                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 1.4 / 2,
                                        ),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap:
                                            () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (
                                                      context,
                                                    ) => MovieDetailScreen(
                                                      movieId:
                                                          moviesRecommended
                                                              .results[index]
                                                              .id,
                                                    ),
                                              ),
                                            ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '$imageUrl${moviesRecommended.results[index].posterPath}',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                      } else {
                        return SizedBox(child: Text('Something Went Wrong'));
                      }
                    },
                  ),
                ],
              );
            } else {
              return SizedBox(
                height: 500,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
