import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'backlog_details_pane.dart';
import 'backlog_list_pane.dart';
import 'backlog_models.dart';

void main() => runApp(const Libero());
// TODO: allow this to be given in a config file
final String dataDir = "${Platform.environment['HOME']}/Documents/libero_data/";

final String dataPath = "${Platform.environment['HOME']}/Documents/libero.json";

class BacklogView extends StatefulWidget {
  final List<BacklogItem> allItems;
  const BacklogView({super.key, required this.allItems});

  @override
  BacklogViewState createState() =>
      BacklogViewState(allItems: {for (var item in allItems) item.id: item});
}

class BacklogViewState extends State<BacklogView> {
  Map<String, BacklogItem> allItems;
  List<BacklogItem> filteredItems;
  BacklogItem? selectedItem;
  bool Function(BacklogItem) _titleFilter = (i) => true;
  bool Function(BacklogItem) _categoryFilter = (i) => true;
  bool Function(BacklogItem) _progressFilter = (i) => true;
  bool Function(BacklogItem) _ratingFilter = (i) => true;

  BacklogViewState({required this.allItems})
      : filteredItems = allItems.values.toList();

  // TODO: I should add some error handling/logging here as well, this isn't bulletproof.
  void addOrUpdate(BacklogItem newItem) {
    setState(() {
      // We copy the image we were given to use to a separate location so it can't get moved out from under us and
      // cause a problem in subsequent app loads.
      if (newItem.imagePath != null) {
        final givenFile = File(newItem.imagePath!);

        // copySync is smart enough to replace if something already exists (thanks dart stdlib!)
        // TODO: no file extensions right now, which may be OK.
        final newPath = "$dataDir${newItem.id}";
        givenFile.copySync(newPath);
        newItem.imagePath = newPath;
      }
      allItems.update(newItem.id, (value) => newItem, ifAbsent: () => newItem);
      // don't need to wait on this future, can just fire-and-forget
      ItemStore.writeBacklog(allItems.values.toList());
      _updateFilteredItems();
    });
  }

  void applyFilter(Filter filter) {
    final f = filter.f;
    switch (filter.type) {
      case FilterType.title:
        _titleFilter = f;
      case FilterType.category:
        _categoryFilter = f;
      case FilterType.progress:
        _progressFilter = f;
      case FilterType.rating:
        _ratingFilter = f;
    }
    setState(() {
      _updateFilteredItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorscheme.base,
        body: Container(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BacklogListPane(
                allItems: allItems.values.toList(),
                filteredItems: filteredItems,
                onApplyFilter: applyFilter,
                onSelectItem: setSelectedItem,
                onSubmitItem: addOrUpdate,
              ),
              BacklogDetailsPane(
                item: selectedItem,
                onSubmitItem: addOrUpdate,
              )
            ],
          ),
        ));
  }

  void remove(BacklogItem item) {
    setState(() {
      allItems.remove(item.id);
    });
  }

  void setSelectedItem(BacklogItem newItem) {
    setState(() {
      selectedItem = newItem;
    });
  }

  void _updateFilteredItems() {
    filteredItems = allItems.values
        .where((item) =>
            _titleFilter(item) &&
            _categoryFilter(item) &&
            _progressFilter(item) &&
            _ratingFilter(item))
        .toList();
  }
}

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

  static void writeBacklog(List<BacklogItem> items) async {
    try {
      final newBacklogData = jsonEncode(items);
      final file = File(dataPath);
      await file.writeAsString(newBacklogData);
    } catch (e) {
      exit(1);
    }
  }
}

class Libero extends StatelessWidget {
  const Libero({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Libero',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colorscheme.base),
      ),
      home: FutureBuilder(
          future: ItemStore.readBacklog(),
          builder: (context, items) {
            if (items.hasData) {
              return BacklogView(allItems: items.data!);
            }
            return const Text(
              "Loading...",
              style: TextStyle(color: Colors.red),
            );
          }),
    );
  }
}
