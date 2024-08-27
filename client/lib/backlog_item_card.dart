import 'dart:math';

import 'package:flutter/cupertino.dart';
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
        child: Card(
      color: colorscheme.overlay1,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Ink.image(
                image: AssetImage(item.imageAssetPath ?? 'assets/me_at_balls.jpg'),
                fit: BoxFit.fill,
                child: InkWell(
                  onTap: () {
                    selectItemNotifier.value = item;
                  },
                ),
              ),
              Positioned(
                bottom: 8.0,
                child: Container(
                  width: 200.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(
                          colorscheme.overlay1.red,
                          colorscheme.overlay1.green,
                          colorscheme.overlay1.blue,
                          0.7),
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          item.category.icon,
                          color: Colors.black,
                        ),
                        Text(item.progress.textual.toUpperCase(),
                            style: TextStyle(
                                color: item.progress.color,
                                fontWeight: FontWeight.bold)),
                        Text(
                          item.rating != null
                              ? item.rating!.clamp(1, 10).toString()
                              : "N/A",
                          style: TextStyle(
                              color: getRatingColor(item.rating),
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ],
          )),
    ));
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
                imageAssetPath: 'assets/hades_cover.jpeg',
            genre: "Fantasy"),
        selectItemNotifier: selectItemNotifier),
    BacklogItemCard(
        BacklogItem(
            category: BacklogItemCategory.book,
            title: "The Doors of Stone",
            progress: BacklogItemProgress.backlog,
                imageAssetPath: 'assets/the_doors_of_stone.jpg',
            genre: "Fantasy"),
        selectItemNotifier: selectItemNotifier),
    BacklogItemCard(
        BacklogItem(
            category: BacklogItemCategory.movie,
            title: "The Matrix Resurrections",
            progress: BacklogItemProgress.dnf,
                imageAssetPath: 'assets/matrix_resurrections.jpg',
            genre: "Sci-Fi"),
        selectItemNotifier: selectItemNotifier),
    BacklogItemCard(
        BacklogItem(
            category: BacklogItemCategory.show,
            title: "Blue Eye Samurai",
            progress: BacklogItemProgress.inProgress,
            favorite: false,
            replay: false,
            notes: "foo",
            rating: 8,
                imageAssetPath: 'assets/blue_eye_samuri.jpg',
            genre: "Action"),
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
