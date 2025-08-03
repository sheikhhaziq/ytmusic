import 'package:json_annotation/json_annotation.dart';
import 'package:ytmusic/models/browse_page.dart';
import 'package:ytmusic/models/section.dart';
import 'package:ytmusic/utils/traverse.dart';

part 'artist.g.dart';

@JsonSerializable()
class YTArtist {
  @JsonKey(readValue: _extractTitle)
  String title;
  @JsonKey(readValue: _extractBrowseId)
  String id;
  @JsonKey(readValue: _extractEndpoint)
  Map endpoint;

  YTArtist({required this.title, required this.id, required this.endpoint});

  factory YTArtist.fromJson(Map<String, dynamic> json) =>
      _$YTArtistFromJson(json);

  Map<String, dynamic> toJson() => _$YTArtistToJson(this);

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
class YTArtistPage {
  YTPageHeader header;
  List<YTSection> sections;
  String? continuation;

  YTArtistPage({
    required this.header,
    required this.sections,
    required this.continuation,
  });

  factory YTArtistPage.fromJson(Map<String, dynamic> json) =>
      _$YTArtistPageFromJson(json);

  Map<String, dynamic> toJson() => _$YTArtistPageToJson(this);
}
