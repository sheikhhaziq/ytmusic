import 'package:ytmusic/models/yt_item.dart';

// part 'item_continuation.g.dart';

// @JsonSerializable()
class YTItemContinuation {
  List<YTItem> items;
  String? continuation;

  YTItemContinuation({required this.items, required this.continuation});

  // factory YTItemContinuation.fromJson(Map<String, dynamic> json) =>
  //     _$YTItemContinuationFromJson(json);

  // Map<String, dynamic> toJson() => _$YTItemContinuationToJson(this);
}
