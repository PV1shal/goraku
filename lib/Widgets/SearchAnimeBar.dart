import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goraku/Models/SearchMetaModel.dart';
import 'package:http/http.dart' as http;

class SearchAnimeBar extends SearchDelegate {
  Future<SearchMetaModel> fetchSearchData() async {
    final response = await http
        .get(Uri.parse("https://goraku-api.vercel.app/anime/gogoanime/$query"));

    if (response.statusCode == 200) {
      return SearchMetaModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error fetching data");
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text("Enter Name and Click Search"));
    } else {
      return FutureBuilder(
        future: fetchSearchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.results.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    print("wasd");
                  },
                  child: Card(
                    elevation: 3,
                    child: Container(
                      height: 150,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            snapshot.data!.results[index].image,
                            width: 150,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.results[index].title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  snapshot.data!.results[index].releaseDate,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  snapshot.data!.results[index].subOrDub,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text("Enter Name and Click Search"),
    );
  }
}
