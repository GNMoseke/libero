import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';

Flavor colorscheme = catppuccin.mocha;

class BacklogItem {
  // uses UUIDs
  final String id;
  BacklogItemCategory category;
  String title;
  BacklogItemProgress progress;
  bool? favorite;
  bool? replay;
  String? notes;
  int? rating;
  String? genre;
  String? imagePath;

  BacklogItem(this.category, this.title, this.progress, this.favorite,
      this.replay, this.notes, this.rating, this.genre, this.imagePath)
      : id = const Uuid().v4();

  BacklogItem.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        category = BacklogItemCategory.values
            .byName((json['category'] as String).toLowerCase()),
        title = json['title'] as String,
        progress = BacklogItemProgress.values
            .byName((json['progress'] as String).toLowerCase()),
        favorite = json['favorite'] as bool?,
        replay = json['replay'] as bool?,
        notes = json['notes'] as String?,
        rating = json['rating'] as int?,
        genre = json['genre'] as String?,
        imagePath = json['imagePath'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'category': category.name.toLowerCase().toString(),
        'title': title,
        'progress': progress.name.toLowerCase().toString(),
        if (favorite != null) 'favorite': favorite,
        if (replay != null) 'replay': replay,
        if (notes != null) 'notes': notes,
        if (rating != null) 'rating': rating,
        if (genre != null) 'genre': genre,
        if (imagePath != null) 'imagePath': imagePath
      };
}

enum BacklogItemCategory {
  game,
  movie,
  book,
  show,
  all;

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
      case BacklogItemCategory.all:
        return Icons.all_inclusive;
      default:
        return Icons.question_mark;
    }
  }

  static List<DropdownMenuEntry<BacklogItemCategory>> get fullMenuItems =>
      BacklogItemCategory.values.map((e) => e.menuItem).toList();

  static List<DropdownMenuEntry<BacklogItemCategory>> get withoutAll =>
      BacklogItemCategory.values
          .where((e) => e != BacklogItemCategory.all)
          .map((e) => e.menuItem)
          .toList();

  DropdownMenuEntry<BacklogItemCategory> get menuItem => DropdownMenuEntry(
      value: this, label: name.toUpperCase(), leadingIcon: Icon(icon));
}

enum BacklogItemProgress {
  backlog,
  inprogress,
  complete,
  dnf,
  all;

  String get textual =>
      this == BacklogItemProgress.inprogress ? "In Progress" : name;

  DropdownMenuEntry<BacklogItemProgress> get menuItem => DropdownMenuEntry(
      value: this,
      label: textual.toUpperCase(),
      leadingIcon: Icon(icon, color: color),
      style: MenuItemButton.styleFrom(foregroundColor: color));

  static List<DropdownMenuEntry<BacklogItemProgress>> get fullMenuItems =>
      BacklogItemProgress.values.map((e) => e.menuItem).toList();

  static List<DropdownMenuEntry<BacklogItemProgress>> get withoutAll =>
      BacklogItemProgress.values
          .where((e) => e != BacklogItemProgress.all)
          .map((e) => e.menuItem)
          .toList();

  Color get color {
    switch (this) {
      case BacklogItemProgress.backlog:
        return colorscheme.subtext1;
      case BacklogItemProgress.inprogress:
        return colorscheme.peach;
      case BacklogItemProgress.complete:
        return colorscheme.green;
      case BacklogItemProgress.dnf:
        return colorscheme.red;
      case BacklogItemProgress.all:
        return colorscheme.surface0;
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
      case BacklogItemProgress.all:
        return Icons.all_inclusive;
    }
  }
}

class Filter {
  Filter({required this.type, required this.f});
  final FilterType type;
  final bool Function(BacklogItem) f;
}

enum FilterType {
  title,
  category,
  progress,
  rating;
}

Color getRatingColor(int? rating) {
  switch (rating) {
    case 1:
      return colorscheme.red;
    case 2:
      return colorscheme.red;
    case 3:
      return colorscheme.red;
    case 4:
      return colorscheme.yellow;
    case 5:
      return colorscheme.yellow;
    case 6:
      return colorscheme.yellow;
    case 7:
      return colorscheme.teal;
    case 8:
      return colorscheme.teal;
    case 9:
      return colorscheme.green;
    case 10:
      return colorscheme.green;
    default:
      return colorscheme.subtext0;
  }
}

List<DropdownMenuEntry<int>> ratingMenuEntries(bool all) {
  var ret = List.generate(
      10,
      (index) =>
          DropdownMenuEntry(value: index + 1, label: (index + 1).toString()));

  all
      ? ret.add(const DropdownMenuEntry(value: 0, label: "ALL"))
      : ret.add(const DropdownMenuEntry(value: 0, label: "N/A"));
  return ret;
}
