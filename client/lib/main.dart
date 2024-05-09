import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'BacklogModels.dart';

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
      home: BacklogPane(),
    );
  }
}

class BacklogPane extends StatelessWidget {
  final selectedItem = new ValueNotifier<BacklogItem?>(null);

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
                    const SizedBox(
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
                              [
                            Column(children: testBacklogItems(selectedItem))
                          ]),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              color: colorscheme.surface0, width: 2.0)),
                      child: Center(
                          child: ValueListenableBuilder<BacklogItem?>(
                              valueListenable: selectedItem,
                              builder: (context, value, child) {
                                return BacklogItemDetails(selectedItem);
                              }))))
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
        SizedBox(
            width: 500,
            child: SearchBar(
              hintText: "Title",
              backgroundColor: MaterialStatePropertyAll(colorscheme.overlay1),
            )), //TODO: add onSubmitted for search
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
                  label: const Text("Progress",
                      style: TextStyle(color: Colors.black, fontSize: 14.0)),
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
                label: const Text("Rating",
                    style: TextStyle(color: Colors.black, fontSize: 14.0)),
                onSelected: (value) {
                  // TODO: append filter to only selected rating
                },
              ),
            )),
      ],
    );
  }
}

List<BacklogItemCard> testBacklogItems(
    ValueNotifier<BacklogItem?> selectItemNotifier) {
  var ret = [
    BacklogItemCard(
        BacklogItem(
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
            genre: "Fantasy"),
        selectItemNotifier: selectItemNotifier),
    BacklogItemCard(
        BacklogItem(
            category: BacklogItemCategory.book,
            title: "The Doors of Stone",
            progress: BacklogItemProgress.backlog,
            genre: "Fantasy"),
        selectItemNotifier: selectItemNotifier),
    BacklogItemCard(
        BacklogItem(
            category: BacklogItemCategory.movie,
            title: "The Matrix Resurrections",
            progress: BacklogItemProgress.dnf,
            genre: "Sci-Fi"),
        selectItemNotifier: selectItemNotifier),
    BacklogItemCard(
        BacklogItem(
            category: BacklogItemCategory.show,
            title: "Caillou",
            progress: BacklogItemProgress.inProgress,
            favorite: false,
            replay: false,
            notes: "foo",
            rating: 1,
            genre: "Horror"),
        selectItemNotifier: selectItemNotifier)
  ];

  for (var i = 0; i < 30; i++) {
    ret.add(BacklogItemCard(
        BacklogItem(
            category: BacklogItemCategory
                .values[Random().nextInt(BacklogItemCategory.values.length)],
            title: "Foo",
            progress: BacklogItemProgress.backlog),
        selectItemNotifier: selectItemNotifier));
  }

  return ret;
}

class BacklogItemDetails extends StatelessWidget {
  final ValueListenable<BacklogItem?> currentItem;

  BacklogItemDetails(this.currentItem);

  @override
  Widget build(BuildContext context) {
    if (currentItem.value != null) {
      return Text(currentItem.value!.title);
    }
    return const Text("Nada");
  }
}

class BacklogItemCard extends StatelessWidget {
  const BacklogItemCard(this.item,
      {super.key, required this.selectItemNotifier});
  final BacklogItem item;
  final ValueNotifier<BacklogItem?> selectItemNotifier;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorscheme.overlay1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
              width: 1000, // TODO: this should be a relative amount
              child: ListTile(
                title: BacklogItemInfoBar(item: item),
                onTap: () {
                  selectItemNotifier.value = item;
                },
              ) /*ExpansionTile(
              iconColor: Colors.black,
              textColor: Colors.black,
              controlAffinity: ListTileControlAffinity.leading,
              title: BacklogItemInfoBar(item: item),
              children: [BacklogItemDetails(item: item)],
            ),*/
              )
        ],
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
                  item.rating != null
                      ? item.rating!.clamp(1, 10).toString()
                      : "N/A",
                  style: TextStyle(
                      fontSize: item.rating != null ? 24.0 : 18.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
      title: Center(
        child: Text(
          item.title.toUpperCase(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.black),
        ),
      ),
      trailing: Text(
        item.progress.textual.toUpperCase(),
        style: TextStyle(color: item.progress.getColor()),
      ),
    );
  }
}
