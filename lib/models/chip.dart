
// part 'chip.g.dart';

// @JsonSerializable()
class YTChip {
  String title;
  Map endpoint;

  YTChip({required this.title, required this.endpoint});
  // factory YTChip.fromJson(Map<String, dynamic> json) => _$YTChipFromJson(json);

  // Map<String, dynamic> toJson() => _$YTChipToJson(this);
}
