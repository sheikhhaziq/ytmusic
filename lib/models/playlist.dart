import 'package:ytmusic/models/browse_page.dart';
import 'package:ytmusic/models/models.dart';

// part 'playlist.g.dart';

// @JsonSerializable()
class YTPlaylistPage {
  YTPageHeader header;
  List<YTSection> sections;
  String? continuation;

  YTPlaylistPage({
    required this.header,
    required this.sections,
    required this.continuation,
  });

  // factory YTPlaylistPage.fromJson(Map<String, dynamic> json) =>
  //     _$YTPlaylistPageFromJson(json);

  // Map<String, dynamic> toJson() => _$YTPlaylistPageToJson(this);
}

// @JsonSerializable()
class YTPlaylistContinuationPage {
  List<YTSection> sections;
  String? continuation;

  YTPlaylistContinuationPage({
    required this.sections,
    required this.continuation,
  });

  // factory YTPlaylistContinuationPage.fromJson(Map<String, dynamic> json) =>
  //     _$YTPlaylistContinuationPageFromJson(json);

  // Map<String, dynamic> toJson() => _$YTPlaylistContinuationPageToJson(this);
}
