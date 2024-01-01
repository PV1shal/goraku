import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goraku/Models/RecentEpisodesModel.dart';
import 'package:goraku/Screens/WatchEpisodePage.dart';
import 'package:http/http.dart' as http;

class AnimePage extends StatefulWidget {
  const AnimePage({Key? key}) : super(key: key);

  @override
  State<AnimePage> createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  late Future<RecentEpisodesModel> recentEpisodes;
  ScrollController scrollController = ScrollController();
  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    recentEpisodes = fetchData();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
        fetchData().then((newData) {
          setState(() {
            recentEpisodes = recentEpisodes.then((existingData) =>
                RecentEpisodesModel(
                    episodes: existingData.episodes + newData.episodes,
                    currentPage: newData.currentPage,
                    hasNextPage: newData.hasNextPage));
            isLoading = false;
          });
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          print("Error fetching more data: $error");
        });
      }
    }
  }

  Future<RecentEpisodesModel> fetchData() async {
    final response = await http.get(Uri.parse(
        "https://goraku-api.vercel.app/anime/gogoanime/recent-episodes?page=$currentPage"));

    if (response.statusCode == 200) {
      setState(() {
        currentPage++;
      });
      return RecentEpisodesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load recent episodes');
    }
  }

  Widget buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime',
      theme: ThemeData(colorScheme: const ColorScheme.dark()),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Anime',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: FutureBuilder(
          future: recentEpisodes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo is ScrollEndNotification) {
                    scrollListener();
                  }
                  return false;
                },
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount:
                      snapshot.data!.episodes.length + (isLoading ? 1 : 0),
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    if (index < snapshot.data!.episodes.length) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WatchEpisodePage(
                                        episode: snapshot.data!.episodes[index],
                                      )));
                        },
                        splashColor: Colors.blue.withAlpha(30),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                    snapshot.data!.episodes[index].image,
                                    fit: BoxFit.cover, errorBuilder:
                                        (BuildContext context, Object exception,
                                            StackTrace? stackTrace) {
                                  return const Center(
                                    child: Text('Failed to load image'),
                                  );
                                }),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.black.withOpacity(0.5),
                                  child: Text(
                                    "${snapshot.data!.episodes[index].title} ${snapshot.data!.episodes[index].episodeNumber}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return buildLoadingIndicator();
                    }
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Failed to load recent episodes'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
