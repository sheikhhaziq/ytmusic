// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YTPodcastPage _$YTPodcastPageFromJson(Map<String, dynamic> json) =>
    YTPodcastPage(
      header: YTPageHeader.fromJson(json['header'] as Map<String, dynamic>),
      sections: (json['sections'] as List<dynamic>)
          .map((e) => YTSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      continuation: json['continuation'] as String?,
    );

Map<String, dynamic> _$YTPodcastPageToJson(YTPodcastPage instance) =>
    <String, dynamic>{
      'header': instance.header,
      'sections': instance.sections,
      'continuation': instance.continuation,
    };

YTPodcastContinuationPage _$YTPodcastContinuationPageFromJson(
  Map<String, dynamic> json,
) => YTPodcastContinuationPage(
  sections: (json['sections'] as List<dynamic>)
      .map((e) => YTSection.fromJson(e as Map<String, dynamic>))
      .toList(),
  continuation: json['continuation'] as String?,
);

Map<String, dynamic> _$YTPodcastContinuationPageToJson(
  YTPodcastContinuationPage instance,
) => <String, dynamic>{
  'sections': instance.sections,
  'continuation': instance.continuation,
};
