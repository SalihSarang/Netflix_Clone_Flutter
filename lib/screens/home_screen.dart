import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/models/now_playing_model.dart';
import 'package:netflix_clone/models/tv_series_model.dart';
import 'package:netflix_clone/models/upcoming_models.dart';
import 'package:netflix_clone/screens/search_screen.dart';
import 'package:netflix_clone/services/api_services.dart';
import 'package:netflix_clone/widgets/custom_corousel.dart';
import 'package:netflix_clone/widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UpcomingMovieModel> upcomingFuture;
  late Future<NowPlayingModel> nowPlayingFuture;
  late Future<TvSeriesModel> topRatedSeries;
  ApiServices apiServices = ApiServices();
  @override
  void initState() {
    upcomingFuture = apiServices.getUpcomingMovies();
    nowPlayingFuture = apiServices.getNowPlaying();
    topRatedSeries = apiServices.getTvSeries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          'assets/logo.png',
          height: 65,
          width: 200,
          fit: BoxFit.contain,
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SearchScreen(),
                  fullscreenDialog: false,
                ),
              );
            },
            child: Icon(Icons.search, color: Colors.white, size: 30),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(color: Colors.blue, height: 30, width: 30),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: topRatedSeries,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CustomCorousel(data: snapshot.data!);
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),

                UpcomingMovieCard(
                  future: upcomingFuture,
                  headLineText: "Upcoming Movies",
                ),
                SizedBox(height: 20),
                NowPlayingMovieCard(
                  future: nowPlayingFuture,
                  headLineText: "Now Playing",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
