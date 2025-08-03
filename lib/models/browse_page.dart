import 'package:json_annotation/json_annotation.dart';
import 'package:ytmusic/models/section.dart';
import 'package:ytmusic/models/thumbnail.dart';

part 'browse_page.g.dart';

@JsonSerializable()
class YTBrowsePage {
  YTPageHeader? header;
  List<YTSection> sections;

  YTBrowsePage({this.header, required this.sections});

  factory YTBrowsePage.fromJson(Map<String, dynamic> json) =>
      _$YTBrowsePageFromJson(json);

  Map<String, dynamic> toJson() => _$YTBrowsePageToJson(this);
}

@JsonSerializable()
class YTPageHeader {
  String title;
  String subtitle;
  String secondSubtitle;
  String description;
  List<YTThumbnail> thumbnails;
  Map<String, dynamic>? playEndpoint;
  Map<String, dynamic>? radioEndpoint;

  Map<String, dynamic>? shuffleEndpoint;

  YTPageHeader({
    required this.title,
    required this.subtitle,
    required this.secondSubtitle,
    required this.description,
    required this.thumbnails,
    required this.playEndpoint,
    required this.radioEndpoint,
    required this.shuffleEndpoint,
  });

  factory YTPageHeader.fromJson(Map<String, dynamic> json) =>
      _$YTPageHeaderFromJson(json);

  Map<String, dynamic> toJson() => _$YTPageHeaderToJson(this);
}
