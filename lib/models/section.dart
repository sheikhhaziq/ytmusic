import 'package:json_annotation/json_annotation.dart';
import 'package:ytmusic/enums/enums.dart';
import 'package:ytmusic/enums/section_item_type.dart';
import 'package:ytmusic/models/album.dart';
import 'package:ytmusic/models/artist.dart';
import 'package:ytmusic/models/thumbnail.dart';

part 'section.g.dart';

@JsonSerializable()
class YTSection {
  String title;
  String? strapline;
  YTSectionTrailing? trailing;
  List<YTSectionItem> items;
  YTSectionType type;
  String? continuation;

  YTSection({
    required this.title,
    this.strapline,
    this.trailing,
    required this.items,
    this.continuation,
    this.type = YTSectionType.row,
  });

  factory YTSection.fromJson(Map<String, dynamic> json) =>
      _$YTSectionFromJson(json);

  Map<String, dynamic> toJson() => _$YTSectionToJson(this);

  YTSection copyWith({
    String? title,
    String? strapline,
    YTSectionTrailing? trailing,
    List<YTSectionItem>? items,
    YTSectionType? type,
    String? continuation,
  }) {
    return YTSection(
      title: title ?? this.title,
      strapline: strapline ?? this.strapline,
      trailing: trailing ?? this.trailing,
      items: items ?? this.items,
      type: type ?? this.type,
      continuation: continuation ?? this.continuation,
    );
  }
}

@JsonSerializable()
class YTSectionTrailing {
  String text;
  Map endpoint;
  bool isPlayable;

  YTSectionTrailing({
    required this.text,
    required this.endpoint,
    required this.isPlayable,
  });

  factory YTSectionTrailing.fromJson(Map<String, dynamic> json) =>
      _$YTSectionTrailingFromJson(json);

  Map<String, dynamic> toJson() => _$YTSectionTrailingToJson(this);
}

@JsonSerializable()
class YTSectionItem {
  String title;
  String? playlistId;
  String? subtitle;
  String? desctiption;
  String id;
  List<YTThumbnail> thumbnails;
  YTSectionItemType type;
  List<YTArtist> artists;
  YTAlbum? album;
  Map? endpoint;
  Map? shuffleEndpoint;
  Map? radioEndpoint;
  bool isRectangle;
  YTSectionItem({
    required this.title,
    required this.id,
    this.playlistId,
    this.desctiption,
    required this.thumbnails,
    this.subtitle,
    required this.type,
    this.artists = const [],
    this.album,
    this.shuffleEndpoint,
    this.radioEndpoint,
    this.endpoint,
    this.isRectangle = false,
  });

  factory YTSectionItem.fromJson(Map<String, dynamic> json) =>
      _$YTSectionItemFromJson(json);

  Map<String, dynamic> toJson() => _$YTSectionItemToJson(this);
}
