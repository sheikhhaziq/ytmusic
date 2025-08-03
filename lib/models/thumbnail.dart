import 'package:json_annotation/json_annotation.dart';

part 'thumbnail.g.dart';

@JsonSerializable()
class YTThumbnail {
  final String url;
  final int width;
  final int height;
  YTThumbnail({required this.url, required this.width, required this.height});

  factory YTThumbnail.fromJson(Map<String, dynamic> json) =>
      _$YTThumbnailFromJson(json);

  /// Connect the generated [_$YTThumbnailToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$YTThumbnailToJson(this);
}
