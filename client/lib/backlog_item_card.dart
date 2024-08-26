import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'backlog_models.dart';

class BacklogItemCard extends StatelessWidget {
  const BacklogItemCard(this.item,
      {super.key, required this.selectItemNotifier});
  final BacklogItem item;
  final ValueNotifier<BacklogItem?> selectItemNotifier;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        title: BacklogItemInfoBar(item: item),
      ),
      child: Card(
          color: colorscheme.overlay1,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
            child: Ink.image(
              image: AssetImage('assets/hades_cover.jpeg'),
              fit: BoxFit.fill,
              child: InkWell(
                onTap: () {
                  selectItemNotifier.value = item;
                },
              ),
            ),
          )),
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
            color: getRatingColor(item.rating),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Transform.scale(
                  scale: 1.6,
                  child: Icon(item.category.icon),
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
      trailing: Text(
        item.progress.textual.toUpperCase(),
        style: TextStyle(color: item.progress.color),
      ),
    );
  }
}

// MARK: tester

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
