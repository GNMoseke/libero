import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
