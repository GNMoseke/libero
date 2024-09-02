import 'dart:io';

import 'package:flutter/material.dart';
import 'backlog_models.dart';

class BacklogItemCard extends StatelessWidget {
  const BacklogItemCard(
      {required this.item, required this.onSelectItem, super.key});
  final BacklogItem item;

  final ValueChanged<BacklogItem> onSelectItem;

  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: Card(
      color: colorscheme.surface2,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              item.imagePath != null
                  ? Ink.image(
                      image: FileImage(File(item.imagePath!)),
                      fit: BoxFit.fill,
                      child: InkWell(
                        onTap: () {
                          onSelectItem(item);
                        },
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        onSelectItem(item);
                      },
                      child: Center(
                        child: Text(item.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 32.0)),
                      ),
                    ),
              Positioned(
                bottom: 8.0,
                child: Container(
                  width: 200.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(
                          colorscheme.crust.red,
                          colorscheme.crust.green,
                          colorscheme.crust.blue,
                          0.8),
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          item.category.icon,
                          color: colorscheme.overlay2,
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
