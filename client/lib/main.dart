import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'backlog_details_pane.dart';
import 'backlog_list_pane.dart';
import 'backlog_models.dart';

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

class Khares extends StatelessWidget {
  const Khares({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khares',
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

  void addOrUpdate(BacklogItem newItem) {
    setState(() {
      allItems.update(newItem.id, (value) => newItem, ifAbsent: () => newItem);
      _updateFilteredItems();
    });
  }

  void remove(BacklogItem item) {
    setState(() {
      allItems.remove(item.id);
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

  void _updateFilteredItems() {
    filteredItems = allItems.values
        .where((item) =>
            _titleFilter(item) &&
            _categoryFilter(item) &&
            _progressFilter(item) &&
            _ratingFilter(item))
        .toList();
  }

  void setSelectedItem(BacklogItem newItem) {
    setState(() {
      selectedItem = newItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorscheme.base,
        body: Container(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
}

class BacklogView extends StatefulWidget {
  const BacklogView({super.key, required this.allItems});
  final List<BacklogItem> allItems;

  @override
  BacklogViewState createState() =>
      BacklogViewState(allItems: {for (var item in allItems) item.id: item});
}
