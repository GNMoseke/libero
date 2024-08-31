import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'backlog_models.dart';
import 'backlog_item_card.dart';
import 'dart:io';

// TODO: allow this to be given in a config file
final String dataPath = "${Platform.environment['HOME']}/Documents/khares.json";

// I know this singleton approach is probably icky for state management, but this thing will not be writing/reading
// data super frequently. Performance tradeoff seems reasonable for ease of use
class ItemStore {
  static Future<List<BacklogItem>> readBacklog() async {
    try {
      final file = await File(dataPath).readAsString();
      Iterable list = jsonDecode(file);
      List<BacklogItem> items = List<BacklogItem>.from(
          list.map((item) => BacklogItem.fromJson(item)));
      return Future.value(items);
    } catch (e) {
      return Future.value([]);
    }
  }

  static Future<void> writeBacklog() async {
    return Future.value();
  }
}

void main() => runApp(const Khares());

class Khares extends StatefulWidget {
  const Khares({super.key});

  @override
  State<Khares> createState() => _KharesState();
}

class _KharesState extends State<Khares> {
  List<BacklogItem> _allBacklogItems = [];

  @override
  void initState() {
    super.initState();
    ItemStore.readBacklog().then((items) {
      setState(() {
        _allBacklogItems = items;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khares',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colorscheme.base),
      ),
      home: BacklogView(
        allBacklogItems: _allBacklogItems,
      ),
    );
  }
}

class BacklogView extends StatelessWidget {
  BacklogView({super.key, required this.allBacklogItems});
  final selectedItem = ValueNotifier<BacklogItem?>(null);

  final List<BacklogItem> allBacklogItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorscheme.base,
        body: Container(
          padding: const EdgeInsets.all(12.0),
          child: allBacklogItems.isEmpty
              ? const Text("Nothing Here!")
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ChangeNotifierProvider(
                        create: (context) => BacklogListModel(allBacklogItems),
                        child: BacklogListPane(selectedItem: selectedItem)),
                    BacklogDetailsPane(selectedItem: selectedItem)
                  ],
                ),
        ));
  }
}

class BacklogDetailsPane extends StatelessWidget {
  const BacklogDetailsPane({
    super.key,
    required this.selectedItem,
  });

  final ValueNotifier<BacklogItem?> selectedItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: colorscheme.surface0, width: 2.0)),
            child: ValueListenableBuilder<BacklogItem?>(
                valueListenable: selectedItem,
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: BacklogItemDetails(selectedItem),
                  );
                })));
  }
}

class BacklogListPane extends StatelessWidget {
  const BacklogListPane({
    super.key,
    required this.selectedItem,
  });

  final ValueNotifier<BacklogItem?> selectedItem;

  @override
  Widget build(BuildContext context) {
    return Consumer<BacklogListModel>(builder: (context, itemList, child) {
      return SizedBox(
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
                children: List<BacklogItemCard>.from(itemList.items.map((item) {
                  return BacklogItemCard(item,
                      selectItemNotifier: selectedItem);
                })),
              )),
            ],
          ));
    });
  }
}

class BacklogMenuBar extends StatelessWidget {
  const BacklogMenuBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BacklogListModel>(builder: (context, itemList, child) {
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
                onChanged: (text) {
                  itemList.setTitleFilter((i) =>
                      i.title.toLowerCase().contains(text.toLowerCase()));
                },
              )),

          // Category Filter
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              color: colorscheme.overlay1,
              child: DropdownMenu<BacklogItemCategory>(
                dropdownMenuEntries: BacklogItemCategory.fullMenuItems,
                label: const Text(
                  "Category",
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
                onSelected: (value) {
                  value == BacklogItemCategory.all
                      ? itemList.setCategoryFilter((i) => true)
                      : itemList.setCategoryFilter((i) => i.category == value);
                },
              ),
            ),
          ),

          // Progress Filter
          ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                  color: colorscheme.overlay1,
                  child: DropdownMenu<BacklogItemProgress>(
                    dropdownMenuEntries: BacklogItemProgress.fullMenuItems,
                    label: const Text("Progress",
                        style: TextStyle(color: Colors.black, fontSize: 14.0)),
                    onSelected: (value) {
                      value == BacklogItemProgress.all
                          ? itemList.setProgressFilter((i) => true)
                          : itemList
                              .setProgressFilter((i) => i.progress == value);
                    },
                  ))),

          // Rating Filter
          ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                color: colorscheme.overlay1,
                child: DropdownMenu<int>(
                  dropdownMenuEntries: ratingMenuEntries(),
                  label: const Text("Rating",
                      style: TextStyle(color: Colors.black, fontSize: 14.0)),
                  onSelected: (value) {
                    // 0 represents "all"
                    value == 0
                        ? itemList.setRatingFilter((i) => true)
                        : itemList.setRatingFilter((i) => i.rating == value);
                  },
                ),
              )),
        ],
      );
    });
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
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      width: 200,
                      child: Row(
                        children: [
                          // Image
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0)),
                              child: item.imagePath != null
                                  ? Image.asset(
                                      item.imagePath!,
                                      fit: BoxFit.fill,
                                    )
                                  : Icon(Icons.image_rounded),
                            ),
                          ),

                          // Info
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0)),
                            child: Container(
                              width: 50,
                              color: colorscheme.surface1,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Transform.scale(
                                      scale: 1.3,
                                      child: Icon(item.category.icon)),
                                  Transform.scale(
                                      scale: 1.3,
                                      child: Icon(
                                        item.progress.icon,
                                        color: item.progress.color,
                                      )),
                                  if (item.rating != null)
                                    Text(item.rating?.toString() ?? "N/A",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: getRatingColor(item.rating),
                                            fontSize: 24.0)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Title
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
                              color: Colors.black,
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    )
                  ],
                )),
            Divider(
              thickness: 3.0,
              color: colorscheme.surface0,
            ),
            SingleChildScrollView(
              child: Text(
                item.notes ?? "Nothing here!",
                style: const TextStyle(color: Colors.black, fontSize: 14.0),
              ),
            )
          ],
        ),
      );
    }
    return const Text("No Selection");
  }
}
