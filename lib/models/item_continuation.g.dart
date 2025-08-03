// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_continuation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YTItemContinuation _$YTItemContinuationFromJson(Map<String, dynamic> json) =>
    YTItemContinuation(
      items: (json['items'] as List<dynamic>)
          .map((e) => YTSectionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      continuation: json['continuation'] as String?,
    );

Map<String, dynamic> _$YTItemContinuationToJson(YTItemContinuation instance) =>
    <String, dynamic>{
      'items': instance.items,
      'continuation': instance.continuation,
    };
