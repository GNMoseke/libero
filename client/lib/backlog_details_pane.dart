import 'package:flutter/material.dart';
import 'dart:io';
import 'package:khares_client/backlog_card_edit.dart';

import 'backlog_models.dart';

class BacklogDetailsPane extends StatelessWidget {
  const BacklogDetailsPane({
    required this.item,
    required this.onSubmitItem,
    super.key,
  });

  final BacklogItem? item;
  final ValueChanged<BacklogItem> onSubmitItem;

  @override
  Widget build(BuildContext context) {
    const contentPadding = 32.0;
    // magic 6 is the edge inset from the center
    final paneContentWidth =
        (MediaQuery.sizeOf(context).width / 2) - (contentPadding * 2) - 6.0;
    // magic 12 is from the overall edge insets at the top level scaffold
    final paneContentHeight =
        MediaQuery.sizeOf(context).height - (contentPadding * 2) - 12.0;

    return Expanded(
        child: Container(
            padding: const EdgeInsets.only(left: 6.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: colorscheme.surface0, width: 2.0)),
            child: Padding(
              padding: const EdgeInsets.all(contentPadding),
              child: BacklogItemDetails(
                paneContentWidth: paneContentWidth,
                paneContentHeight: paneContentHeight,
                item: item,
                onSubmitItem: onSubmitItem,
              ),
            )));
  }
}

class BacklogItemDetails extends StatelessWidget {
  const BacklogItemDetails(
      {required this.item,
      required this.onSubmitItem,
      required this.paneContentWidth,
      required this.paneContentHeight,
      super.key});
  final BacklogItem? item;
  final ValueChanged<BacklogItem> onSubmitItem;
  final double paneContentWidth;
  final double paneContentHeight;

  @override
  Widget build(BuildContext context) {
    if (item != null) {
      return Scaffold(
        backgroundColor: colorscheme.base,
        floatingActionButton: IconButton.filled(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BacklogItemEditor(
                      item: item,
                      onSubmitItem: onSubmitItem,
                    );
                  });
            },
            icon: const Icon(Icons.edit)),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Column(
          children: [
            _Header(
              item: item!,
              paneContentWidth: paneContentWidth,
              paneContentHeight: paneContentHeight,
            ),
            Divider(
              thickness: 3.0,
              color: colorscheme.surface0,
            ),
            _Body(item: item!)
          ],
        ),
      );
    }
    return const Center(
      child: Text(
        "No Selection",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 32.0),
      ),
    );
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
    required this.paneContentWidth,
    required this.paneContentHeight,
  });

  final BacklogItem item;
  final double paneContentWidth;
  final double paneContentHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: paneContentHeight * 0.24,
        child: Row(
          children: [
            // Image and icons
            _AtAGlance(
              item: item,
              paneContentHeight: paneContentHeight,
              paneContentWidth: paneContentWidth,
            ),

            // Title
            const Padding(padding: EdgeInsets.symmetric(horizontal: 6.0)),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: paneContentWidth * 0.7,
                  child: Text(
                    item.title.toUpperCase(),
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
    required this.paneContentWidth,
    required this.paneContentHeight,
  });

  final BacklogItem item;
  final double paneContentWidth;
  final double paneContentHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(8.0))),
      width: paneContentWidth * 0.24,
      child: Row(
        children: [
          // Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0)),
              child: item.imagePath != null
                  ? Image.file(
                      File(item.imagePath!),
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
              width: paneContentWidth * 0.06,
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
