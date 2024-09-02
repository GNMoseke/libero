import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import 'backlog_models.dart';

class BacklogItemEditor extends StatefulWidget {
  final BacklogItem? item;
  final ValueChanged<BacklogItem> onSubmitItem;

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
        progress = item?.progress ?? BacklogItemProgress.backlog,
        favorite = item?.favorite,
        notes = item?.notes,
        rating = item?.rating,
        genre = item?.genre,
        imagePath = item?.imagePath;

  @override
  State<BacklogItemEditor> createState() => _BacklogItemEditorState();
}

class _BacklogItemEditorState extends State<BacklogItemEditor> {
  final XTypeGroup imageGroup = const XTypeGroup(
      label: 'images', extensions: <String>['jpg', 'png', 'jpeg', 'webp']);

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
              backgroundColor: colorscheme.overlay1,
              floatingActionButton: IconButton.filled(
                  onPressed: () {
                    // simple update case
                    if (widget.item case var existing?) {
                      // These are safe, since when we created this instance they will have been populated.
                      // The user then could have edited them, so we use the newer values.
                      // Note that this does technically allow an empty string as the name... but I am going to allow
                      // that.
                      existing.title = widget.title!;
                      existing.category = widget.category!;
                      existing.progress = widget.progress!;
                      existing.favorite = widget.favorite;
                      existing.notes = widget.notes;
                      existing.rating = widget.rating;
                      existing.genre = widget.genre;
                      existing.imagePath = widget.imagePath;
                      widget.onSubmitItem(existing);
                      Navigator.pop(context);
                    }
                    // create new case
                    else if (widget.title != null &&
                        widget.category != null &&
                        widget.progress != null) {
                      final newItem = BacklogItem(
                          widget.category!,
                          widget.title!,
                          widget.progress!,
                          widget.favorite,
                          false,
                          widget.notes,
                          widget.rating,
                          widget.genre,
                          widget.imagePath);
                      widget.onSubmitItem(newItem);
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
                                initialValue: widget.title,
                                onChanged: (String? newTitle) {
                                  widget.title = newTitle;
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
                                initialValue: widget.genre,
                                onChanged: (String? newGenre) {
                                  widget.genre = newGenre;
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
                              ),
                              width: dialogWidth * 0.5,
                              height: dialogHeight * 0.5,
                              child: widget.imagePath != null
                                  ? Ink.image(
                                      image: FileImage(File(widget.imagePath!)),
                                      fit: BoxFit.fill,
                                      child: InkWell(
                                        onTap: () {
                                          final file = openFile(
                                              acceptedTypeGroups: [imageGroup]);
                                          file.then((value) => setState(() {
                                                widget.imagePath = value?.path;
                                              }));
                                        },
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ))
                                  : InkWell(
                                      onTap: () {
                                        final file = openFile(
                                            acceptedTypeGroups: [imageGroup]);
                                        file.then((value) => setState(() {
                                              widget.imagePath = value?.path;
                                            }));
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
                              child: Column(children: [
                                DropdownMenu<BacklogItemCategory>(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  inputDecorationTheme: InputDecorationTheme(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(8.0))),
                                  width: dialogWidth * 0.3,
                                  initialSelection: widget.category,
                                  leadingIcon: Icon(
                                    widget.category?.icon ?? Icons.new_label,
                                    color: colorscheme.crust,
                                  ),
                                  dropdownMenuEntries:
                                      BacklogItemCategory.withoutAll,
                                  label: const Text("Category",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                  onSelected: (value) {
                                    setState(() {
                                      widget.category = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 32.0),
                                DropdownMenu<BacklogItemProgress>(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  inputDecorationTheme: InputDecorationTheme(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(8.0))),
                                  width: dialogWidth * 0.3,
                                  initialSelection: widget.progress ??
                                      BacklogItemProgress.backlog,
                                  leadingIcon: Icon(widget.progress?.icon ??
                                      BacklogItemProgress.backlog.icon, color: colorscheme.crust),
                                  dropdownMenuEntries:
                                      BacklogItemProgress.withoutAll,
                                  label: const Text("Progress",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                  onSelected: (value) {
                                    setState(() {
                                      widget.progress = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 32.0),
                                DropdownMenu<int>(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  inputDecorationTheme: InputDecorationTheme(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(8.0))),
                                  width: dialogWidth * 0.3,
                                  initialSelection: widget.rating ?? 0,
                                  leadingIcon: Icon(Icons.grade, color: colorscheme.crust),
                                  dropdownMenuEntries: ratingMenuEntries(false),
                                  label: const Text("Rating",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                  onSelected: (value) {
                                                    setState(() {
                                                                                                          
                                    widget.rating = value;
                                                                                                        });
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
                            controller:
                                TextEditingController(text: widget.notes),
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (String? value) {
                              widget.notes = value;
                            },
                          ),
                        ),
                      )
                    ]),
              ),
            )));
  }
}
