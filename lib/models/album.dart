import 'package:json_annotation/json_annotation.dart';
import 'package:ytmusic/models/browse_page.dart';
import 'package:ytmusic/models/section.dart';
import 'package:ytmusic/utils/traverse.dart';

part 'album.g.dart';

@JsonSerializable()
class YTAlbum {
  @JsonKey(readValue: _extractTitle)
  String title;
  @JsonKey(readValue: _extractBrowseId)
  String id;
  @JsonKey(readValue: _extractEndpoint)
  Map endpoint;

  YTAlbum({required this.title, required this.id, required this.endpoint});

  factory YTAlbum.fromJson(Map<String, dynamic> json) =>
      _$YTAlbumFromJson(json);

  Map<String, dynamic> toJson() => _$YTAlbumToJson(this);

  static _extractTitle(Map json, key) {
    return traverseString(json, ['text']) ?? '';
  }

  static _extractBrowseId(Map json, key) {
    return traverseString(json, ['browseEndpoint', 'browseId']) ?? '';
  }

  static _extractEndpoint(Map json, key) {
    return traverse(json, ['browseEndpoint']);
  }
}

@JsonSerializable()
class YTAlbumPage {
  YTPageHeader header;
  List<YTSection> sections;
  String? continuation;

  YTAlbumPage({
    required this.header,
    required this.sections,
    required this.continuation,
  });

  factory YTAlbumPage.fromJson(Map<String, dynamic> json) =>
      _$YTAlbumPageFromJson(json);

  Map<String, dynamic> toJson() => _$YTAlbumPageToJson(this);
}
