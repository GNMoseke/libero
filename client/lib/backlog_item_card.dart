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
      color: colorscheme.overlay1,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              item.imagePath != null
                  ? Ink.image(
                      image: AssetImage(item.imagePath!),
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
                      // FIXME: this is necessary to get the inkwell to fill the card. I tried with FittedBox
                      // and that seemed to not work. There's gotta be a less annoying way to do this.
                      child: SizedBox(
                          width: 300,
                          height: 500,
                          child: Center(
                            child: Text(item.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 32.0)),
                          )),
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
