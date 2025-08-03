import 'package:json_annotation/json_annotation.dart';
import 'package:ytmusic/ytmusic.dart';

part 'item_continuation.g.dart';

@JsonSerializable()
class YTItemContinuation {
  List<YTSectionItem> items;
  String? continuation;

  YTItemContinuation({required this.items, required this.continuation});

  factory YTItemContinuation.fromJson(Map<String, dynamic> json) =>
      _$YTItemContinuationFromJson(json);

  Map<String, dynamic> toJson() => _$YTItemContinuationToJson(this);
}
