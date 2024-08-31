import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'backlog_models.dart';

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

class BacklogItemDetails extends StatelessWidget {
  final ValueListenable<BacklogItem?> currentItem;

  const BacklogItemDetails(this.currentItem, {super.key});

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
            _Header(item: item),
            Divider(
              thickness: 3.0,
              color: colorscheme.surface0,
            ),
            _Body(item: item)
          ],
        ),
      );
    }
    return const Text("No Selection");
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.item,
  });

  final BacklogItem item;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Text(
        item.notes ?? "Nothing here!",
        style: const TextStyle(color: Colors.black, fontSize: 14.0),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.item,
  });

  final BacklogItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 220,
        child: Row(
          children: [
            // Image and icons
            _AtAGlance(item: item),

            // Title
            const Padding(padding: EdgeInsets.symmetric(horizontal: 6.0)),
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
        ));
  }
}

class _AtAGlance extends StatelessWidget {
  const _AtAGlance({
    required this.item,
  });

  final BacklogItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(8.0))),
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
                  : const Icon(Icons.image_rounded),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Transform.scale(scale: 1.3, child: Icon(item.category.icon)),
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
    );
  }
}
