// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YTHomePage _$YTHomePageFromJson(Map<String, dynamic> json) => YTHomePage(
  chips: (json['chips'] as List<dynamic>)
      .map((e) => YTChip.fromJson(e as Map<String, dynamic>))
      .toList(),
  sections: (json['sections'] as List<dynamic>)
      .map((e) => YTSection.fromJson(e as Map<String, dynamic>))
      .toList(),
  continuation: json['continuation'] as String?,
);

Map<String, dynamic> _$YTHomePageToJson(YTHomePage instance) =>
    <String, dynamic>{
      'chips': instance.chips,
      'sections': instance.sections,
      'continuation': instance.continuation,
    };

YTHomeContinuationPage _$YTHomeContinuationPageFromJson(
  Map<String, dynamic> json,
) => YTHomeContinuationPage(
  sections: (json['sections'] as List<dynamic>)
      .map((e) => YTSection.fromJson(e as Map<String, dynamic>))
      .toList(),
  continuation: json['continuation'] as String?,
);

Map<String, dynamic> _$YTHomeContinuationPageToJson(
  YTHomeContinuationPage instance,
) => <String, dynamic>{
  'sections': instance.sections,
  'continuation': instance.continuation,
};
