import 'dart:convert';
import 'dart:math';
// TODO: I wanna get away from using this package if I can
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:catppuccin_flutter/catppuccin_flutter.dart';

Flavor colorscheme = catppuccin.mocha;

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
        colorScheme: ColorScheme.fromSeed(seedColor: colorscheme.base),
      ),
      home: const BacklogPane(),
    );
  }
}

class BacklogPane extends StatelessWidget {
  const BacklogPane({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: IconButton(
          icon: const Icon(Icons.add_outlined),
          onPressed: () {},
        ),
        backgroundColor: Colors.black12,
        body: Container(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 1000,
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                      child: BacklogMenuBar(),
                    ),
                    Expanded(
                      child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
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
                              [Column(children: testBacklogItems())]),
                    ),
                  ],
                ),
              ),
              const Expanded(child: Center(child: Placeholder()))
            ],
          ),
        ));
  }
}

class BacklogMenuBar extends StatelessWidget {
  const BacklogMenuBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(width: 500, child: SearchBar(hintText: "Title")), //TODO: add onSubmitted for search
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            color: colorscheme.overlay1,
            child: DropdownMenu(
              dropdownMenuEntries: BacklogItemCategory.fullMenuItems,
              label: const Text(
                "Type",
                style: TextStyle(color: Colors.black, fontSize: 14.0),
              ),
              onSelected: (value) {
                // TODO: append filter to only selected type
              },
            ),
          ),
        ),
        ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
                color: colorscheme.overlay1,
                child: DropdownMenu(
                  dropdownMenuEntries: BacklogItemProgress.fullMenuItems,
                  label: const Text("Progress", style: TextStyle(color: Colors.black, fontSize: 14.0)),
                  onSelected: (value) {
                    // TODO: append filter to only selected progress
                  },
                ))),
        ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              color: colorscheme.overlay1,
              child: DropdownMenu(
                dropdownMenuEntries: ratingMenuEntries(),
                label: const Text("Rating", style: TextStyle(color: Colors.black, fontSize: 14.0)),
                onSelected: (value) {
                  // TODO: append filter to only selected rating
                },
              ),
            )),
      ],
    );
  }
}


List<BacklogItemCard> testBacklogItems() {
  var ret = [
    BacklogItemCard(BacklogItem(
        category: BacklogItemCategory.game,
        title: "Hades",
        progress: BacklogItemProgress.complete,
        favorite: true,
        replay: true,
        notes: """
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
        title: "Caillou",
        progress: BacklogItemProgress.inProgress,
        favorite: false,
        replay: false,
        notes: "foo",
        rating: 1,
        genre: "Horror"))
  ];

  for (var i = 0; i < 30; i++) {
    ret.add(BacklogItemCard(
        BacklogItem(category: BacklogItemCategory.values[Random().nextInt(BacklogItemCategory.values.length)], title: "Foo", progress: BacklogItemProgress.backlog)));
  }

  return ret;
}


class BacklogItemCard extends StatelessWidget {
  BacklogItemCard(this.item, {super.key});
  final BacklogItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorscheme.overlay1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 1000, // TODO: this should be a relative amount
            child: ExpansionTile(
              iconColor: Colors.black,
              textColor: Colors.black,
              controlAffinity: ListTileControlAffinity.leading,
              title: BacklogItemInfoBar(item: item),
              children: [BacklogItemDetails(item: item)],
            ),
          )
        ],
      ),
    );
  }
}

class BacklogItemDetails extends StatelessWidget {
  const BacklogItemDetails({
    super.key,
    required this.item,
  });

  final BacklogItem item;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
        child: SizedBox(
            height: 700,
            child: DropCapText(
              item.notes ?? "No notes!",
              // TODO: can use igdb here for game cover art, openlibrary for books, moviedb, etc
              dropCap: DropCap(
                  width: 208,
                  height: 300,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0), child: Image.asset('assets/hades_cover.jpeg')),
                      ),
                    ],
                  )),
              style: const TextStyle(fontSize: 20),
            )),
      ),
    );
  }
}

class BacklogItemInfoBar extends StatelessWidget {
  const BacklogItemInfoBar({
    super.key,
    required this.item,
  });

  final BacklogItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 100,
        height: 50.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            // TODO: change this based on the rating
            color: getRatingColor(item.rating),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Transform.scale(
                  scale: 1.6,
                  child: Icon(item.category.getIcon()),
                ),
                Text(
                  item.rating != null ? item.rating!.clamp(1, 10).toString() : "N/A",
                  style: TextStyle(fontSize: item.rating != null ? 24.0 : 18.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
      title: Center(
        child: Text(
          item.title.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.black),
        ),
      ),
      trailing: Text(
        item.progress.textual.toUpperCase(),
        style: TextStyle(color: item.progress.getColor()),
      ),
    );
  }
}

// TODO: color :)
Color getRatingColor(int? rating) {
  switch (rating) {
    case 1: return colorscheme.red;
    case 2: return colorscheme.red;
    case 3: return colorscheme.red;
    case 4: return colorscheme.red;
    case 5: return colorscheme.peach;
    case 6: return colorscheme.peach;
    case 7: return colorscheme.peach;
    case 8: return colorscheme.peach;
    case 9: return colorscheme.green;
    case 10: return colorscheme.green;
    default: return colorscheme.overlay0;
  }
}

List<DropdownMenuEntry> ratingMenuEntries() {
  var ret = List.generate(10, (index) => DropdownMenuEntry(value: index + 1, label: (index + 1).toString()));
  ret.add(const DropdownMenuEntry(value: 0, label: "ALL"));
  return ret;
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

  static List<DropdownMenuEntry> get fullMenuItems {
    var ret = BacklogItemCategory.values.map((e) => e.menuItem).toList();
    ret.add(const DropdownMenuEntry(value: "ALL", label: "ALL", leadingIcon: Icon(Icons.all_inclusive)));
    return ret;
  }

  DropdownMenuEntry get menuItem =>
      DropdownMenuEntry(value: name.toUpperCase(), label: name.toUpperCase(), leadingIcon: Icon(getIcon()));
}

enum BacklogItemProgress {
  backlog,
  inProgress,
  complete,
  dnf;

  String get textual => this == BacklogItemProgress.inProgress ? "In Progress" : name;

  DropdownMenuEntry get menuItem => DropdownMenuEntry(
      value: textual.toUpperCase(),
      label: textual.toUpperCase(),
      style: MenuItemButton.styleFrom(foregroundColor: getColor()));

  static List<DropdownMenuEntry> get fullMenuItems {
    var ret = BacklogItemProgress.values.map((e) => e.menuItem).toList();
    ret.add(const DropdownMenuEntry(value: "ALL", label: "ALL", leadingIcon: Icon(Icons.all_inclusive)));
    return ret;
  }

  Color getColor() {
    switch (this) {
      case BacklogItemProgress.backlog:
        return colorscheme.surface0;
      case BacklogItemProgress.inProgress:
        return colorscheme.peach;
      case BacklogItemProgress.complete:
        return colorscheme.green;
      case BacklogItemProgress.dnf:
        return colorscheme.red;
    }
  }
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
