import 'dart:io';

import 'package:flutter/material.dart';
import 'package:khares_client/backlog_models.dart';

class BacklogItemEditor extends StatelessWidget {
  final BacklogItem? item;
  final ValueChanged<BacklogItem> onSubmitItem;

  // FIXME: there's a smarter way to do this but I've had 2 beers
  BacklogItemCategory? category;
  String? title;
  BacklogItemProgress? progress;
  bool? favorite;
  String? notes;
  int? rating;
  String? genre;
  String? imagePath;

  BacklogItemEditor({super.key, required this.item, required this.onSubmitItem})
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
    final double dialogWidth = (MediaQuery.sizeOf(context).width / 2) * 0.75;
    final double dialogHeight = MediaQuery.sizeOf(context).height * 0.9;

    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: Scaffold(
              backgroundColor: Colors.blueGrey,
              floatingActionButton: IconButton.filled(
                  onPressed: () {
                    // simple update case
                    if (item case var existing?) {
                      // These are safe, since when we created this instance they will have been populated.
                      // The user then could have edited them, so we use the newer values.
                      // Note that this does technically allow an empty string as the name... but I am going to allow
                      // that.
                      existing.title = title!;
                      existing.category = category!;
                      existing.progress = progress!;
                      existing.favorite = favorite;
                      existing.notes = notes;
                      existing.rating = rating;
                      existing.genre = genre;
                      existing.imagePath = imagePath;
                      onSubmitItem(existing);
                      Navigator.pop(context);
                    }
                    // create new case
                    else if (title != null &&
                        category != null &&
                        progress != null) {
                      final newItem = BacklogItem(category!, title!, progress!,
                          favorite, false, notes, rating, genre, imagePath);
                      onSubmitItem(newItem);
                      Navigator.pop(context);
                    }
                    // need to fill in fields
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("Fill in title, category, and progress")));
                    }
                  },
                  icon: const Icon(Icons.check)),
              body: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: (dialogWidth * 0.1) / 8),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Title entry, genre entry
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Title
                            SizedBox(
                              width: dialogWidth * 0.6,
                              child: TextFormField(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                initialValue: title,
                                onChanged: (String? newTitle) {
                                  title = newTitle;
                                },
                                decoration: InputDecoration(
                                    hintText: "Title",
                                    prefixIcon: const Icon(
                                      Icons.title,
                                      color: Colors.black,
                                    ),
                                    border: const OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0))),
                              ),
                            ),

                            // Genre
                            SizedBox(
                              width: dialogWidth * 0.3,
                              child: TextFormField(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                initialValue: genre,
                                onChanged: (String? newGenre) {
                                  genre = newGenre;
                                },
                                decoration: InputDecoration(
                                    hintText: "Genre",
                                    prefixIcon: const Icon(
                                      Icons.theater_comedy,
                                      color: Colors.black,
                                    ),
                                    border: const OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0))),
                              ),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Image entry
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(12.0)),
                              width: dialogWidth * 0.6,
                              height: dialogHeight * 0.5,
                              child: imagePath != null
                                  ? Ink.image(
                                      image: FileImage(File(imagePath!)),
                                      fit: BoxFit.fill,
                                      child: InkWell(
                                        onTap: () {
                                          // TODO: select image here
                                        },
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ))
                                  : InkWell(
                                      onTap: () {
                                        //TODO: select image here
                                      },
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: const Center(
                                        child: Icon(
                                            Icons.add_photo_alternate_rounded),
                                      )),
                            ),

                            // category, completion, rating
                            SizedBox(
                              width: dialogWidth * 0.3,
                              child: Column(
                                  // FIXME: THIS NOT WORK
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    DropdownMenu<BacklogItemCategory>(
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.black),
                                                  borderRadius: BorderRadius
                                                      .circular(8.0)),
                                              border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0))),
                                      width: dialogWidth * 0.3,
                                      initialSelection: category,
                                      dropdownMenuEntries:
                                          BacklogItemCategory.withoutAll,
                                      label: const Text("Category",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0)),
                                      onSelected: (value) {
                                        category = value;
                                      },
                                    ),

                                    const SizedBox(height: 32.0),

                                    DropdownMenu<BacklogItemProgress>(
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.black),
                                                  borderRadius: BorderRadius
                                                      .circular(8.0)),
                                              border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0))),
                                      width: dialogWidth * 0.3,
                                      initialSelection: progress,
                                      dropdownMenuEntries:
                                          BacklogItemProgress.withoutAll,
                                      label: const Text("Progress",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0)),
                                      onSelected: (value) {
                                        progress = value;
                                      },
                                    ),

                                    const SizedBox(height: 32.0),

                                    DropdownMenu<int>(
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.black),
                                                  borderRadius: BorderRadius
                                                      .circular(8.0)),
                                              border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0))),
                                      width: dialogWidth * 0.3,
                                      initialSelection: rating,
                                      dropdownMenuEntries:
                                          ratingMenuEntries(false),
                                      label: const Text("Rating",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0)),
                                      onSelected: (value) {
                                        rating = value;
                                      },
                                    ),
                                  ]),
                            )
                          ]),

                      // Notes
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12.0)),
                        width: dialogWidth * 0.9 + ((dialogWidth * 0.1) / 3),
                        height: dialogHeight * 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: null,
                            controller: TextEditingController(text: notes),
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.black),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (String? value) {
                              notes = value;
                            },
                          ),
                        ),
                      )
                    ]),
              ),
            )));
  }
}
