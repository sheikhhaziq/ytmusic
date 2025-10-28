import 'package:ytmusic/enums/enums.dart';
import 'package:ytmusic/models/yt_item.dart';


class YTSection {
  String title;
  String? strapline;
  YTSectionTrailing? trailing;
  List<YTItem> items;
  YTSectionType type;
  String? continuation;
  int? itemsPerColumn;

  YTSection({
    required this.title,
    this.strapline,
    this.trailing,
    required this.items,
    this.continuation,
    this.type = YTSectionType.row,
    this.itemsPerColumn,
  });


  YTSection copyWith({
    String? title,
    String? strapline,
    YTSectionTrailing? trailing,
    List<YTItem>? items,
    YTSectionType? type,
    String? continuation,
    int? itemsPerColumn,
  }) {
    return YTSection(
      title: title ?? this.title,
      strapline: strapline ?? this.strapline,
      trailing: trailing ?? this.trailing,
      items: items ?? this.items,
      type: type ?? this.type,
      continuation: continuation ?? this.continuation,
      itemsPerColumn: itemsPerColumn??this.itemsPerColumn,
    );
  }
}

class YTSectionTrailing {
  String text;
  Map endpoint;
  bool isPlayable;

  YTSectionTrailing({
    required this.text,
    required this.endpoint,
    required this.isPlayable,
  });

  
}