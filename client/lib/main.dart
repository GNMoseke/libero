import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        floatingActionButton: IconButton.filled(
          icon: const Icon(Icons.add_outlined),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        backgroundColor: colorscheme.base,
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
                      child: ValueListenableBuilder<BacklogItem?>(
                          valueListenable: selectedItem,
                          builder: (context, value, child) {
                            return Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: BacklogItemDetails(selectedItem),
                            );
                          })))
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
      final item = currentItem.value!;
      return Scaffold(
        backgroundColor: colorscheme.base,
        floatingActionButton:
            IconButton.filled(onPressed: () {}, icon: const Icon(Icons.edit)),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Column(
          children: [
            SizedBox(
                height: 220,
                child: Row(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0)),
                          child: Image.asset(
                            'assets/hades_cover.jpeg',
                            height: 220,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0)),
                          child: Container(
                            width: 50,
                            color: colorscheme.surface1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Transform.scale(
                                    scale: 1.3,
                                    child: Icon(item.category.getIcon())),
                                if (item.rating != null)
                                  Text(item.rating?.toString() ?? "N/A",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: getRatingColor(item.rating),
                                          fontSize: 24.0)),
                                Transform.scale(
                                    scale: 1.3,
                                    child: Icon(
                                      item.progress.icon,
                                      color: item.progress.getColor(),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 600,
                          child: Text(
                            item.title.toUpperCase(),
                            // FIXME: this will still overflow without an ellipsis because of the column thing if the text is too long
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 64.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                letterSpacing: -0.5,
                                wordSpacing: -0.5,
                                height: 1.0),
                          ),
                        ),
                        Text(
                          item.genre ?? "Unknown",
                          style: const TextStyle(
                              fontSize: 16.0, fontStyle: FontStyle.italic),
                        ),
                      ],
                    )
                  ],
                )),
            Divider(
              thickness: 3.0,
              color: colorscheme.surface0,
            ),
            Text(
              item.notes ?? "Nothing here!",
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
      );
    }
    return const Text("No Selection");
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
