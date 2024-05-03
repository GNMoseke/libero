import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //late Future<List<BacklogItem>> futureItems;

  @override
  void initState() {
    super.initState();
    //futureItems = getBacklogItems();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khares',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Khares'),
          ),
          body: Center(
              child: /*FutureBuilder<List<BacklogItem>>(
            future: futureItems,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!
                    .map((backlogItem) =>
                        "${backlogItem.category.name.toUpperCase()}: ${backlogItem.title} | ${backlogItem.progress.name} | ${backlogItem.rating ?? "unrated"} ")
                    .join("\n"));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),*/
                  Column(children: testBacklogItems()))),
    );
  }
}

List<BacklogItemCard> testBacklogItems() {
  return [
    BacklogItemCard(BacklogItem(
        category: BacklogItemCategory.game,
        title: "Hades",
        progress: BacklogItemProgress.complete,
        favorite: true,
        replay: true,
        notes: "foo",
        rating: 10,
        genre: "Fantasy")),
    BacklogItemCard(BacklogItem(
        category: BacklogItemCategory.book,
        title: "The Doors of Stone",
        progress: BacklogItemProgress.backlog,
        genre: "Fantasy")),
    BacklogItemCard(BacklogItem(
        category: BacklogItemCategory.movie,
        title: "The Matrix Resurrections",
        progress: BacklogItemProgress.dnf,
        genre: "Sci-Fi")),
    BacklogItemCard(BacklogItem(
        category: BacklogItemCategory.show,
        title: "Avatar: The Last Airbender",
        progress: BacklogItemProgress.inProgress,
        favorite: true,
        replay: true,
        notes: "foo",
        rating: 10,
        genre: "Fantasy"))
  ];
}

class BacklogItemCard extends StatelessWidget {
  BacklogItemCard(this.item, {super.key});
  final BacklogItem item;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.blueGrey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 500, // TODO: this should be a relative amount
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
                SizedBox(
                    width: 450, // TODO this should be some relative amount
                    child: ListTile(
                      leading: Icon(item.category.getIcon()),
                      title: Text(item.title.toUpperCase()),
                      trailing: Text(item.progress.name.toUpperCase()),
                    )),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

Future<List<BacklogItem>> getBacklogItems() async {
  final resp = await http.get(Uri.parse("http://localhost:8000/backlog"));
  if (resp.statusCode == 200) {
    List<dynamic> itemsList = jsonDecode(resp.body);
    return itemsList.map((item) => BacklogItem.fromJson(item)).toList();
  }
  throw Exception("Failed to load backlog items");
}

enum BacklogItemCategory {
  game,
  movie,
  book,
  show;

  IconData getIcon() {
    switch (this) {
      case BacklogItemCategory.game:
        return Icons.sports_esports;
      case BacklogItemCategory.movie:
        return Icons.movie;
      case BacklogItemCategory.book:
        return Icons.book;
      case BacklogItemCategory.show:
        return Icons.tv;
      default:
        return Icons.question_mark;
    }
  }
}

enum BacklogItemProgress {
  backlog,
  inProgress,
  complete,
  dnf,
}

class BacklogItem {
  final BacklogItemCategory category;
  final String title;
  final BacklogItemProgress progress;
  final bool? favorite;
  final bool? replay;
  final String? notes;
  final int? rating;
  final String? genre;
  // TODO: enable
  // final List<String>? tags

  BacklogItem(
      {required this.category,
      required this.title,
      required this.progress,
      this.favorite,
      this.replay,
      this.notes,
      this.rating,
      this.genre});

  BacklogItem.fromJson(Map<String, dynamic> json)
      : category = BacklogItemCategory.values.byName((json['category'] as String).toLowerCase()),
        title = json['title'] as String,
        progress = BacklogItemProgress.values.byName((json['progress'] as String).toLowerCase()),
        favorite = json['favorite'] as bool?,
        replay = json['replay'] as bool?,
        notes = json['notes'] as String?,
        rating = json['rating'] as int?,
        genre = json['genre'] as String?;

  Map<String, dynamic> toJson() => {
        'category': category.toString(),
        'title': title,
        'progress': progress.toString(),
        if (favorite != null) 'favorite': favorite,
        if (replay != null) 'replay': replay,
        if (notes != null) 'notes': notes,
        if (rating != null) 'rating': rating,
        if (genre != null) 'genre': genre
      };
}
