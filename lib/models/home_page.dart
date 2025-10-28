import 'package:ytmusic/models/chip.dart';
import 'package:ytmusic/models/section.dart';

// part 'home_page.g.dart';

// @JsonSerializable()
class YTHomePage {
  List<YTChip> chips;
  List<YTSection> sections;
  String? continuation;

  YTHomePage({required this.chips, required this.sections, this.continuation});
  // factory YTHomePage.fromJson(Map<String, dynamic> json) =>
  //     _$YTHomePageFromJson(json);

  // Map<String, dynamic> toJson() => _$YTHomePageToJson(this);
}

// @JsonSerializable()
class YTHomeContinuationPage {
  List<YTSection> sections;
  String? continuation;

  YTHomeContinuationPage({required this.sections, this.continuation});
  // factory YTHomeContinuationPage.fromJson(Map<String, dynamic> json) =>
  //     _$YTHomeContinuationPageFromJson(json);

  // Map<String, dynamic> toJson() => _$YTHomeContinuationPageToJson(this);
}
