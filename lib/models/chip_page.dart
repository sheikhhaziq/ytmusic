import 'package:ytmusic/models/section.dart';

// part 'chip_page.g.dart';

// @JsonSerializable()
class YTChipPage {
  List<YTSection> sections;
  String? continuation;

  YTChipPage({required this.sections, this.continuation});
  // factory YTChipPage.fromJson(Map<String, dynamic> json) =>
  //     _$YTChipPageFromJson(json);

  // Map<String, dynamic> toJson() => _$YTChipPageToJson(this);
}

// @JsonSerializable()
class YTChipContinuationPage {
  List<YTSection> sections;
  String? continuation;

  YTChipContinuationPage({required this.sections, this.continuation});
  // factory YTChipContinuationPage.fromJson(Map<String, dynamic> json) =>
  //     _$YTChipContinuationPageFromJson(json);

  // Map<String, dynamic> toJson() => _$YTChipContinuationPageToJson(this);
}
