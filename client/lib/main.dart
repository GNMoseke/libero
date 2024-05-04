import 'dart:convert';
// TODO: I wanna get away from using this package if I can
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
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
          /*appBar: AppBar(
            title: const Text('Khares'),
          ),*/
          body: ListView(
              children: /*FutureBuilder<List<BacklogItem>>(
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
                  [Column(children: testBacklogItems())])),
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
        notes:
            """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
            
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
            """,
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
              width: 1000, // TODO: this should be a relative amount
              child: ExpansionTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: ListTile(
                  leading: Transform.scale(
                    scale: 2.0,
                    child: Icon(item.category.getIcon()),
                  ),
                  title: Center(
                    child: Text(
                      item.title.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.black),
                    ),
                  ),
                  trailing: Text(item.progress.textual.toUpperCase()),
                ),
                children: [
                  ColoredBox(
                    color: Colors.blueAccent,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                          height: 700,
                          child: DropCapText(
                            dropCapPadding: const EdgeInsets.only(right: 8.0),
                            item.notes ?? "No notes!",
                            // TODO: can use igdb here for game cover art, openlibrary for books, moviedb, etc
                            dropCap: DropCap(
                                width: 300,
                                height: 300,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
                                      child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.asset('assets/hades_cover.jpeg')),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(item.rating != null ? item.rating.toString() : "Unrated",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 48.0, color: Colors.black)),
                                        ],
                                      ),
                                    ) // TODO: would like to make color change with score
                                  ],
                                )),
                            style: const TextStyle(fontSize: 20),
                          )),
                    ),
                  )
                ],
              ),
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
  dnf;

  String get textual => this == BacklogItemProgress.inProgress ? "In Progress" : name;
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
