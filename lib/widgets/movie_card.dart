import 'package:flutter/material.dart';
import 'package:netflix_clone/common/utils.dart';
import 'package:netflix_clone/models/now_playing_model.dart';
import 'package:netflix_clone/models/upcoming_models.dart';

class NowPlayingMovieCard extends StatelessWidget {
  final Future<NowPlayingModel> future;
  final String headLineText;

  const NowPlayingMovieCard({
    super.key,
    required this.future,
    required this.headLineText,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NowPlayingModel>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
          return const Center(child: Text('No movies found'));
        }

        final data = snapshot.data!.results;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headLineText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final movie = data[index];
                  final posterPath = movie.posterPath;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          posterPath.isNotEmpty
                              ? Image.network(
                                "$imageUrl$posterPath",
                                width: 145,
                                fit: BoxFit.cover,
                              )
                              : Container(
                                width: 145,
                                color: Colors.grey[800],
                                alignment: Alignment.center,
                                child: const Text(
                                  'No Image',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class UpcomingMovieCard extends StatelessWidget {
  final Future<UpcomingMovieModel> future;
  final String headLineText;

  const UpcomingMovieCard({
    super.key,
    required this.future,
    required this.headLineText,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UpcomingMovieModel>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
          return const Center(child: Text('No movies found'));
        }

        final data = snapshot.data!.results;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headLineText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final movie = data[index];
                  final posterPath = movie.posterPath;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          posterPath.isNotEmpty
                              ? Image.network(
                                "$imageUrl$posterPath",
                                width: 145,
                                fit: BoxFit.cover,
                              )
                              : Container(
                                width: 145,
                                color: Colors.grey[800],
                                alignment: Alignment.center,
                                child: const Text(
                                  'No Image',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
