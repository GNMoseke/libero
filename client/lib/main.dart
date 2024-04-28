import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<BacklogItem>> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = getBacklogItems();
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
          child: FutureBuilder<List<BacklogItem>>(
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
          ),
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

enum BacklogItemCategory { game, movie, book, show }

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
