import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goraku/Models/AnimeEpisodeInfoModel.dart';
import 'package:goraku/Models/SearchResultsModel.dart';
import 'package:http/http.dart' as http;

class AnimeInfoPage extends StatelessWidget {
  late SearchResultsModel searchResultsModel;
  bool isExpanded = false;
  AnimeInfoPage({super.key, required this.searchResultsModel});

  Future<AnimeEpisodeInfoModel> fetchAnimeInfo(String id) async {
    final response = await http.get(
        Uri.parse('https://goraku-api.vercel.app/anime/gogoanime/info/${id}'));
    return AnimeEpisodeInfoModel.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(searchResultsModel.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: FutureBuilder(
        future: fetchAnimeInfo(searchResultsModel.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
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
                    children: [
                      Row(
                        children: [
                          Image.network(
                            snapshot.data!.image,
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width * 0.35,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
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
                        ],
                      ),
                      ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {},
                        children: [
                          ExpansionPanel(
                            headerBuilder: (context, isExpanded) {
                              return const ListTile(
                                title: Text(
                                  "Genres",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                            body: Wrap(
                              children: snapshot.data!.genres
                                  .map((genre) => Container(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Chip(
                                          label: Text(genre),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            isExpanded: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
