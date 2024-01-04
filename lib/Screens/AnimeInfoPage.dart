import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goraku/Models/AnimeEpisodeInfoModel.dart';
import 'package:goraku/Models/SearchResultsModel.dart';
import 'package:goraku/Screens/WatchEpisodePage.dart';
import 'package:http/http.dart' as http;

class AnimeInfoPage extends StatefulWidget {
  final SearchResultsModel searchResultsModel;

  AnimeInfoPage({Key? key, required this.searchResultsModel}) : super(key: key);

  @override
  _AnimeInfoPageState createState() => _AnimeInfoPageState();
}

class _AnimeInfoPageState extends State<AnimeInfoPage> {
  late Future<AnimeEpisodeInfoModel> animeInfoFuture;
  bool descriptionExpanded = true;

  @override
  void initState() {
    super.initState();
    animeInfoFuture = fetchAnimeInfo(widget.searchResultsModel.id);
  }

  Future<AnimeEpisodeInfoModel> fetchAnimeInfo(String id) async {
    final response = await http.get(
        Uri.parse('https://goraku-api.vercel.app/anime/gogoanime/info/$id'));
    return AnimeEpisodeInfoModel.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.searchResultsModel.title,
          overflow: TextOverflow.fade,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: FutureBuilder(
        future: animeInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0),
                        ],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.network(
                      snapshot.data!.image,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1,
                      left: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              snapshot.data!.image,
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width * 0.35,
                              fit: BoxFit.cover,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.fade,
                                    ),
                                    Text(
                                      snapshot.data!.releaseDate,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (snapshot.data!.status.toLowerCase() ==
                                        "completed")
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color: Colors.green,
                                            size: 18,
                                          ),
                                          Text(
                                            "Completed",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      const Row(
                                        children: [
                                          Icon(Icons.watch_later_outlined,
                                              color: Colors.blue, size: 18),
                                          Text(
                                            "Ongoing",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          children: snapshot.data!.genres
                              .map((genre) => Container(
                                    margin: const EdgeInsets.all(5),
                                    child: Chip(
                                      label: Text(genre),
                                    ),
                                  ))
                              .toList(),
                        ),
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              descriptionExpanded = !descriptionExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              headerBuilder: (context, isExpanded) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: const Text(
                                    "Description",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                              body: Container(
                                padding: const EdgeInsets.only(right: 15),
                                child: Wrap(
                                  children: [
                                    Text(
                                      snapshot.data!.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                    const Text(
                                      "\nAlternate Names:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Wrap(
                                      children: snapshot.data!.otherName
                                          .split(",")
                                          .map((name) => Row(
                                                children: [
                                                  Text(name.trim()),
                                                  const SizedBox(width: 5),
                                                ],
                                              ))
                                          .toList(),
                                    )
                                  ],
                                ),
                              ),
                              isExpanded: descriptionExpanded,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Episodes (${snapshot.data!.totalEpisodes})",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: snapshot.data!.episodes
                              .map(
                                (episode) => Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 30,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return WatchEpisodePage(
                                            episode: episode);
                                      }));
                                    },
                                    child: Text(
                                      "Episode ${episode.episodeNumber.toString()}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
