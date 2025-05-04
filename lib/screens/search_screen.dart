import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/popular_movie_model.dart';
import 'package:netflix_clone/models/search_model.dart';
import 'package:netflix_clone/screens/movie_detail_screen.dart';
import 'package:netflix_clone/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  ApiServices apiServices = ApiServices();
  late Future<PopularMovieModel> popularMoviesFuture;

  SearchModel? searchModel;
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      setState(() {
        searchModel = null;
      });
    } else {
      _debounce = Timer(const Duration(milliseconds: 800), () {
        apiServices.getSearchedMovie(query).then((results) {
          setState(() {
            searchModel = results;
          });
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    popularMoviesFuture = apiServices.getPopularMovie();
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              SizedBox(
                height: 50,
                child: CupertinoSearchTextField(
                  padding: const EdgeInsets.all(10),
                  controller: searchController,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 30,
                  ),
                  suffixIcon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                    size: 30,
                  ),
                  style: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.grey.shade900,
                  onChanged: _onSearchChanged,
                ),
              ),
              const SizedBox(height: 20),
              searchController.text.isEmpty
                  ? FutureBuilder<PopularMovieModel>(
                    future: popularMoviesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.results.isEmpty) {
                        return const Center(child: Text('No movies found'));
                      }

                      final data = snapshot.data!.results;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Top Searches',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final movie = data[index];
                              final posterPath = movie.posterPath;
                              final movieId = movie.id;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => MovieDetailScreen(
                                              movieId: movieId,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                            posterPath.isNotEmpty
                                                ? Image.network(
                                                  "$imageUrl$posterPath",
                                                  width: 100,
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                )
                                                : Container(
                                                  width: 100,
                                                  height: 150,
                                                  color: Colors.grey[800],
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'No Image',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          movie.originalTitle,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  )
                  : searchModel == null
                  ? const SizedBox.shrink()
                  : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 5,
                        ),
                    itemCount: searchModel?.results.length,
                    itemBuilder: (context, index) {
                      String imagePath =
                          searchModel!.results[index].backdropPath ?? '';
                      String movieName =
                          searchModel!.results[index].originalTitle;

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => MovieDetailScreen(
                                        movieId: searchModel!.results[index].id,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      imagePath.isNotEmpty
                                          ? "$imageUrl$imagePath"
                                          : "https://via.placeholder.com/150",
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => const Center(
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) =>
                                          const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: 100,
                            child: Text(
                              movieName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
