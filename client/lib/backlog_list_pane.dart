import 'package:flutter/material.dart';

import 'backlog_card_edit.dart';
import 'backlog_item_card.dart';
import 'backlog_models.dart';

class BacklogListPane extends StatelessWidget {
  final List<BacklogItem> allItems;

  final List<BacklogItem> filteredItems;
  final ValueChanged<Filter> onApplyFilter;
  final ValueChanged<BacklogItem> onSelectItem;
  final ValueChanged<BacklogItem> onSubmitItem;
  const BacklogListPane({
    required this.allItems,
    required this.filteredItems,
    required this.onApplyFilter,
    required this.onSelectItem,
    required this.onSubmitItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width / 2,
        child: Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: BacklogMenuBar(
                  onApplyFilter: onApplyFilter,
                  onSubmitItem: onSubmitItem,
                ),
              ),
              Flexible(
                  child: GridView.count(
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                crossAxisCount: 4,
                scrollDirection: Axis.vertical,
                childAspectRatio: 0.65,
                children: List<BacklogItemCard>.from(filteredItems.map((item) {
                  return BacklogItemCard(
                    item: item,
                    onSelectItem: onSelectItem,
                  );
                })),
              )),
            ],
          ),
        ));
  }
}

class BacklogMenuBar extends StatelessWidget {
  final double componentHeight = 54;

  final ValueChanged<Filter> onApplyFilter;
  final ValueChanged<BacklogItem> onSubmitItem;
  const BacklogMenuBar({
    super.key,
    required this.onApplyFilter,
    required this.onSubmitItem,
  });

  @override
  Widget build(BuildContext context) {
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
                            return BacklogItemEditor(
                              item: null,
                              onSubmitItem: onSubmitItem,
                            );
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
                backgroundColor: MaterialStatePropertyAll(colorscheme.overlay1),
                onChanged: (text) {
                  onApplyFilter((Filter(
                      type: FilterType.title,
                      f: (i) =>
                          i.title.toLowerCase().contains(text.toLowerCase()))));
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
                      ? onApplyFilter(
                          Filter(type: FilterType.category, f: ((i) => true)))
                      : onApplyFilter(Filter(
                          type: FilterType.category,
                          f: (i) => i.category == value));
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
                        style: TextStyle(color: Colors.black, fontSize: 14.0)),
                    onSelected: (value) {
                      value == BacklogItemProgress.all
                          ? onApplyFilter(Filter(
                              type: FilterType.progress, f: ((i) => true)))
                          : onApplyFilter(Filter(
                              type: FilterType.progress,
                              f: (i) => i.progress == value));
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
                  dropdownMenuEntries: ratingMenuEntries(true),
                  label: const Text("Rating",
                      style: TextStyle(color: Colors.black, fontSize: 14.0)),
                  onSelected: (value) {
                    // 0 represents "all"
                    value == 0
                        ? onApplyFilter(
                            Filter(type: FilterType.rating, f: ((i) => true)))
                        : onApplyFilter(Filter(
                            type: FilterType.rating,
                            f: (i) => i.rating == value));
                  },
                ),
              )),
        ),
      ],
    );
  }
}
