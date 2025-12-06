import 'package:json_annotation/json_annotation.dart';
import 'package:ytmusic/utils/traverse.dart';

part 'artist.g.dart';

@JsonSerializable()
class YTArtistBasic {
  YTArtistBasic({
    required this.title,
    required this.id,
    required this.endpoint,
  });

  factory YTArtistBasic.fromJson(Map<String, dynamic> json) =>
      _$YTArtistBasicFromJson(json);
  @JsonKey(readValue: _extractTitle)
  String title;
  @JsonKey(readValue: _extractBrowseId)
  String id;
  @JsonKey(readValue: _extractEndpoint)
  Map endpoint;

  Map<String, dynamic> toJson() => _$YTArtistBasicToJson(this);

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
