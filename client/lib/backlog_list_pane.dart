import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:khares_client/backlog_card_edit.dart';
import 'package:provider/provider.dart';

import 'backlog_item_card.dart';
import 'backlog_models.dart';

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
  final double componentHeight = 54;

  @override
  Widget build(BuildContext context) {
    // Something here is smelly but I don't know enough about provider to know what it is.
    // see no evil hear no evil speak no evil
    var listState = Provider.of<BacklogListModel>(context, listen: false);
    return Consumer<BacklogListModel>(builder: (childContext, itemList, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Add new button
          Flexible(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                  height: componentHeight,
                  width: componentHeight,
                  color: colorscheme.overlay1,
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return ChangeNotifierProvider<
                                      BacklogListModel>.value(
                                  value: listState, child: BacklogItemEditor());
                            });
                      },
                      icon: const Icon(Icons.note_add))),
            ),
          ),

          // Search Bar
          Flexible(
            flex: 5,
            child: SizedBox(
                height: componentHeight,
                child: SearchBar(
                  hintText: "Title",
                  leading: const Icon(Icons.search_rounded),
                  backgroundColor:
                      MaterialStatePropertyAll(colorscheme.overlay1),
                  onChanged: (text) {
                    itemList.setTitleFilter((i) =>
                        i.title.toLowerCase().contains(text.toLowerCase()));
                  },
                )),
          ),

          // Category Filter
          Flexible(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                height: componentHeight,
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
                        : itemList
                            .setCategoryFilter((i) => i.category == value);
                  },
                ),
              ),
            ),
          ),

          // Progress Filter
          Flexible(
            flex: 2,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                    height: componentHeight,
                    color: colorscheme.overlay1,
                    child: DropdownMenu<BacklogItemProgress>(
                      dropdownMenuEntries: BacklogItemProgress.fullMenuItems,
                      label: const Text("Progress",
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.0)),
                      onSelected: (value) {
                        value == BacklogItemProgress.all
                            ? itemList.setProgressFilter((i) => true)
                            : itemList
                                .setProgressFilter((i) => i.progress == value);
                      },
                    ))),
          ),

          // Rating Filter
          Flexible(
            flex: 2,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  height: componentHeight,
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
          ),
        ],
      );
    });
  }
}
