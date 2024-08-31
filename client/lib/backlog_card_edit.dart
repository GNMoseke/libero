import 'package:flutter/material.dart';
import 'package:khares_client/backlog_models.dart';
import 'package:provider/provider.dart';

class BacklogItemEditor extends StatelessWidget {
  BacklogItem? item;

  // FIXME: there's a smarter way to do this but I've had 2 beers
  final BacklogItemCategory? category;
  final String? title;
  final BacklogItemProgress? progress;
  final bool? favorite;
  final String? notes;
  final int? rating;
  final String? genre;
  final String? imagePath;

  BacklogItemEditor({super.key, this.item})
      : title = item?.title,
        category = item?.category,
        progress = item?.progress,
        favorite = item?.favorite,
        notes = item?.notes,
        rating = item?.rating,
        genre = item?.genre,
        imagePath = item?.imagePath;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SizedBox(
            width: MediaQuery.sizeOf(context).width / 2,
            height: MediaQuery.sizeOf(context).height * 0.9,
            child: Scaffold(
              backgroundColor: Colors.blueGrey,
              floatingActionButton: Consumer<BacklogListModel>(
                  builder: (context, itemList, child) {
                return IconButton.filled(
                    onPressed: () {
                      // simple update case
                      if (item case var existing?) {
                        // These are safe, since when we created this instance they will have been populated.
                        // The user then could have edited them, so we use the newer values
                        existing.title = title!;
                        existing.category = category!;
                        existing.progress = progress!;
                        existing.favorite = favorite;
                        existing.notes = notes;
                        existing.rating = rating;
                        existing.genre = genre;
                        existing.imagePath = imagePath;
                        itemList.addOrUpdate(existing);
                      }
                      // create new case
                      else if (title != null &&
                          category != null &&
                          progress != null) {
                        final newItem = BacklogItem(
                            category!,
                            title!,
                            progress!,
                            favorite,
                            false,
                            notes,
                            rating,
                            genre,
                            imagePath);
                        itemList.addOrUpdate(newItem);
                      }
                      // need to fill in fields
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Fill in title, category, and progress")));
                      }
                    },
                    icon: Icon(Icons.check));
              }),
              body: Column(children: [
                // Title entry, genre entry
                Row(children: [Placeholder(), Placeholder()]),
                Row(children: [
                  // Image entry
                  Placeholder(),

                  // category, completion, rating
                  Column(
                      children: [Placeholder(), Placeholder(), Placeholder()])
                ]),
                // notes
                Placeholder()
              ]),
            )));
  }
}
