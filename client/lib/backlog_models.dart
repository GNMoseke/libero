import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';

Flavor colorscheme = catppuccin.mocha;

Color getRatingColor(int? rating) {
  switch (rating) {
    case 1:
      return colorscheme.red;
    case 2:
      return colorscheme.red;
    case 3:
      return colorscheme.red;
    case 4:
      return colorscheme.red;
    case 5:
      return colorscheme.peach;
    case 6:
      return colorscheme.peach;
    case 7:
      return Colors.lime;
    case 8:
      return Colors.lime;
    case 9:
      return colorscheme.green;
    case 10:
      return colorscheme.green;
    default:
      return Colors.black;
  }
}

List<DropdownMenuEntry> ratingMenuEntries() {
  var ret = List.generate(
      10,
      (index) =>
          DropdownMenuEntry(value: index + 1, label: (index + 1).toString()));
  ret.add(const DropdownMenuEntry(value: 0, label: "ALL"));
  return ret;
}

Future<List<BacklogItem>> getBacklogItems() async {
  final resp = await http.get(Uri.parse("http://localhost:8000/backlog"));
  if (resp.statusCode == 200) {
    List<dynamic> itemsList = jsonDecode(resp.body);
    return itemsList.map((item) => BacklogItem.fromJson(item)).toList();
  }
  throw Exception("Failed to load backlog items");
}

enum BacklogItemCategory {
  game,
  movie,
  book,
  show;

  IconData get icon {
    switch (this) {
      case BacklogItemCategory.game:
        return Icons.sports_esports;
      case BacklogItemCategory.movie:
        return Icons.movie;
      case BacklogItemCategory.book:
        return Icons.book;
      case BacklogItemCategory.show:
        return Icons.tv;
      default:
        return Icons.question_mark;
    }
  }

  static List<DropdownMenuEntry> get fullMenuItems {
    var ret = BacklogItemCategory.values.map((e) => e.menuItem).toList();
    ret.add(const DropdownMenuEntry(
        value: "ALL", label: "ALL", leadingIcon: Icon(Icons.all_inclusive)));
    return ret;
  }

  DropdownMenuEntry get menuItem => DropdownMenuEntry(
      value: name.toUpperCase(),
      label: name.toUpperCase(),
      leadingIcon: Icon(icon));
}

enum BacklogItemProgress {
  backlog,
  inprogress,
  complete,
  dnf;

  String get textual =>
      this == BacklogItemProgress.inprogress ? "In Progress" : name;

  DropdownMenuEntry get menuItem => DropdownMenuEntry(
      value: textual.toUpperCase(),
      label: textual.toUpperCase(),
      leadingIcon: Icon(icon, color: color),
      style: MenuItemButton.styleFrom(foregroundColor: color));

  static List<DropdownMenuEntry> get fullMenuItems {
    var ret = BacklogItemProgress.values.map((e) => e.menuItem).toList();
    ret.add(const DropdownMenuEntry(
        value: "ALL", label: "ALL", leadingIcon: Icon(Icons.all_inclusive)));
    return ret;
  }

  Color get color {
    switch (this) {
      case BacklogItemProgress.backlog:
        return colorscheme.surface0;
      case BacklogItemProgress.inprogress:
        return colorscheme.peach;
      case BacklogItemProgress.complete:
        return colorscheme.green;
      case BacklogItemProgress.dnf:
        return colorscheme.red;
    }
  }

  IconData get icon {
    switch (this) {
      case BacklogItemProgress.backlog:
        return Icons.history_toggle_off;
      case BacklogItemProgress.inprogress:
        return Icons.pending;
      case BacklogItemProgress.complete:
        return Icons.check_circle;
      case BacklogItemProgress.dnf:
        return Icons.dangerous;
    }
  }
}

class BacklogItem {
  final BacklogItemCategory category;
  final String title;
  final BacklogItemProgress progress;
  final bool? favorite;
  final bool? replay;
  final String? notes;
  final int? rating;
  final String? genre;
    final String? imageAssetPath;
  // TODO: enable
  // final List<String>? tags

  BacklogItem(
      {required this.category,
      required this.title,
      required this.progress,
      this.favorite,
      this.replay,
      this.notes,
      this.rating,
      this.genre,
    this.imageAssetPath});

  BacklogItem.fromJson(Map<String, dynamic> json)
      : category = BacklogItemCategory.values
            .byName((json['category'] as String).toLowerCase()),
        title = json['title'] as String,
        progress = BacklogItemProgress.values
            .byName((json['progress'] as String).toLowerCase()),
        favorite = json['favorite'] as bool?,
        replay = json['replay'] as bool?,
        notes = json['notes'] as String?,
        rating = json['rating'] as int?,
        genre = json['genre'] as String?,
        imageAssetPath = json['imageAssetPath'] as String?;

  Map<String, dynamic> toJson() => {
        'category': category.toString(),
        'title': title,
        'progress': progress.toString(),
        if (favorite != null) 'favorite': favorite,
        if (replay != null) 'replay': replay,
        if (notes != null) 'notes': notes,
        if (rating != null) 'rating': rating,
        if (genre != null) 'genre': genre,
        if (imageAssetPath != null) 'imageAssetPath' : imageAssetPath
      };
}
