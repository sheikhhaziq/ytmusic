import 'package:json_annotation/json_annotation.dart';
import 'package:ytmusic/models/browse_page.dart';
import 'package:ytmusic/models/section.dart';

part 'podcast.g.dart';

@JsonSerializable()
class YTPodcastPage {
  YTPageHeader header;
  List<YTSection> sections;
  String? continuation;

  YTPodcastPage({
    required this.header,
    required this.sections,
    required this.continuation,
  });

  factory YTPodcastPage.fromJson(Map<String, dynamic> json) =>
      _$YTPodcastPageFromJson(json);

  Map<String, dynamic> toJson() => _$YTPodcastPageToJson(this);
}

@JsonSerializable()
class YTPodcastContinuationPage {
  List<YTSection> sections;
  String? continuation;

  YTPodcastContinuationPage({
    required this.sections,
    required this.continuation,
  });

  factory YTPodcastContinuationPage.fromJson(Map<String, dynamic> json) =>
      _$YTPodcastContinuationPageFromJson(json);

  Map<String, dynamic> toJson() => _$YTPodcastContinuationPageToJson(this);
}
