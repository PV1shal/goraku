import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:goraku/Models/EpisodeModel.dart';
import 'package:goraku/Models/WatchEpisodeModel.dart';
import 'package:goraku/Widgets/VideoPlayerWidget.dart';
import 'package:http/http.dart' as http;

class WatchEpisodePage extends StatefulWidget {
  late final EpisodeModel episode;

  WatchEpisodePage({super.key, required this.episode});

  State<WatchEpisodePage> createState() => _WatchEpisodePageState();
}

class _WatchEpisodePageState extends State<WatchEpisodePage> {
  late Future<WatchEpisodeModel> episodeSources;
  late String _quality;
  late List<String> dropDownQualities;

  @override
  void initState() {
    super.initState();
    episodeSources = fetchEpisodeSources();
    _quality = "default";
  }

  Future<WatchEpisodeModel> fetchEpisodeSources() async {
    final response = await http.get(Uri.parse(
        "https://goraku-api.vercel.app/anime/gogoanime/watch/${widget.episode.episodeId}"));
    return WatchEpisodeModel.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: episodeSources,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: GestureDetector(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.episode.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Episode: ${widget.episode.episodeNumber.toString()}",
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: VideoPlayerWidget(urls: snapshot.data!.sources),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
