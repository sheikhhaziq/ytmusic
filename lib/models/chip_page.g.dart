// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chip_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YTChipPage _$YTChipPageFromJson(Map<String, dynamic> json) => YTChipPage(
  sections: (json['sections'] as List<dynamic>)
      .map((e) => YTSection.fromJson(e as Map<String, dynamic>))
      .toList(),
  continuation: json['continuation'] as String?,
);

Map<String, dynamic> _$YTChipPageToJson(YTChipPage instance) =>
    <String, dynamic>{
      'sections': instance.sections,
      'continuation': instance.continuation,
    };

YTChipContinuationPage _$YTChipContinuationPageFromJson(
  Map<String, dynamic> json,
) => YTChipContinuationPage(
  sections: (json['sections'] as List<dynamic>)
      .map((e) => YTSection.fromJson(e as Map<String, dynamic>))
      .toList(),
  continuation: json['continuation'] as String?,
);

Map<String, dynamic> _$YTChipContinuationPageToJson(
  YTChipContinuationPage instance,
) => <String, dynamic>{
  'sections': instance.sections,
  'continuation': instance.continuation,
};
