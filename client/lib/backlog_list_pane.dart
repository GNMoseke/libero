import 'package:flutter/material.dart';
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
                leading: const Icon(Icons.search_rounded),
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
