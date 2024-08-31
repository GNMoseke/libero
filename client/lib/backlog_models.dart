import 'dart:collection';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';

class BacklogListModel extends ChangeNotifier {
  Map<String, BacklogItem> _allItems = {};

  bool Function(BacklogItem) _titleFilter = (i) => true;
  bool Function(BacklogItem) _categoryFilter = (i) => true;
  bool Function(BacklogItem) _progressFilter = (i) => true;
  bool Function(BacklogItem) _ratingFilter = (i) => true;

  BacklogListModel(List<BacklogItem> items) {
    _allItems = {for (var item in items) item.id: item};
  }

  UnmodifiableListView<BacklogItem> get items {
    return UnmodifiableListView(_allItems.values.where((item) =>
        _titleFilter(item) &&
        _categoryFilter(item) &&
        _progressFilter(item) &&
        _ratingFilter(item)));
  }

  UnmodifiableListView<BacklogItem> get allitems =>
      UnmodifiableListView(_allItems.values);

  void addOrUpdate(BacklogItem newItem) {
    _allItems.update(newItem.id, (value) => newItem, ifAbsent: () => newItem);
    notifyListeners();
  }

  void remove(BacklogItem toRemove) {
    _allItems.remove(toRemove.id);
    notifyListeners();
  }

  void setTitleFilter(bool Function(BacklogItem) f) {
    _titleFilter = f;
    notifyListeners();
  }

  void setCategoryFilter(bool Function(BacklogItem) f) {
    _categoryFilter = f;
    notifyListeners();
  }

  void setProgressFilter(bool Function(BacklogItem) f) {
    _progressFilter = f;
    notifyListeners();
  }

  void setRatingFilter(bool Function(BacklogItem) f) {
    _ratingFilter = f;
    notifyListeners();
  }
}

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

List<DropdownMenuEntry<int>> ratingMenuEntries() {
  var ret = List.generate(
      10,
      (index) =>
          DropdownMenuEntry(value: index + 1, label: (index + 1).toString()));
  ret.add(const DropdownMenuEntry(value: 0, label: "ALL"));
  return ret;
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
        'category': category.toString(),
        'title': title,
        'progress': progress.toString(),
        if (favorite != null) 'favorite': favorite,
        if (replay != null) 'replay': replay,
        if (notes != null) 'notes': notes,
        if (rating != null) 'rating': rating,
        if (genre != null) 'genre': genre,
        if (imagePath != null) 'imagePath': imagePath
      };
}
