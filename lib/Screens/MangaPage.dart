import 'package:flutter/material.dart';

class MangaPage extends StatefulWidget {
  MangaPage({super.key});

  State<MangaPage> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manga',
      theme: ThemeData(colorScheme: const ColorScheme.dark()),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Manga",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  TextButton(onPressed: () {}, child: Text("Manga 1")),
                ],
              ),
              Row(
                children: <Widget>[
                  TextButton(onPressed: () {}, child: Text("Manga 2")),
                ],
              ),
              Row(
                children: <Widget>[
                  TextButton(onPressed: () {}, child: Text("Manga 3")),
                ],
              ),
            ],
          )),
    );
  }
}
