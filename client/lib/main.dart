import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'backlog_models.dart';
import 'backlog_item_card.dart';

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
  final selectedItem = ValueNotifier<BacklogItem?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorscheme.base,
        body: Container(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 70,
                      child: BacklogMenuBar(),
                    ),
                    Flexible(
                      child: GridView.count(
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          crossAxisCount: 4,
                          scrollDirection: Axis.vertical,
                          childAspectRatio: 0.65,
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
                              testBacklogItems(selectedItem)),
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
        // Add new button
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          // FIXME: height is a bit wonky on this
          child: Container(
              color: colorscheme.overlay1,
              child: IconButton(
                  onPressed: () {}, icon: const Icon(Icons.note_add))),
        ),

        // Search Bar
        SizedBox(
            width: 400,
            child: SearchBar(
              hintText: "Title",
              backgroundColor: MaterialStatePropertyAll(colorscheme.overlay1),
            )), //TODO: add onSubmitted for search

        // Type Filter
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

        // Progress Filter
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

        // Rating Filter
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
                            item.imageAssetPath ?? 'assets/me_at_balls.jpg',
                            fit: BoxFit.fill,
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
                                    child: Icon(item.category.icon)),
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
                                      color: item.progress.color,
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

