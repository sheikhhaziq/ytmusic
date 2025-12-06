import 'package:json_annotation/json_annotation.dart';
import 'package:ytmusic/utils/traverse.dart';

part 'album.g.dart';

@JsonSerializable()
class YTAlbumBasic {
  YTAlbumBasic({required this.title, required this.id, required this.endpoint});

  factory YTAlbumBasic.fromJson(Map<String, dynamic> json) =>
      _$YTAlbumBasicFromJson(json);
  @JsonKey(readValue: _extractTitle)
  String title;
  @JsonKey(readValue: _extractBrowseId)
  String id;
  @JsonKey(readValue: _extractEndpoint)
  Map endpoint;

  Map<String, dynamic> toJson() => _$YTAlbumBasicToJson(this);

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
