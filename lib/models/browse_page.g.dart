// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YTBrowsePage _$YTBrowsePageFromJson(Map<String, dynamic> json) => YTBrowsePage(
  header: json['header'] == null
      ? null
      : YTPageHeader.fromJson(json['header'] as Map<String, dynamic>),
  sections: (json['sections'] as List<dynamic>)
      .map((e) => YTSection.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$YTBrowsePageToJson(YTBrowsePage instance) =>
    <String, dynamic>{'header': instance.header, 'sections': instance.sections};

YTPageHeader _$YTPageHeaderFromJson(Map<String, dynamic> json) => YTPageHeader(
  title: json['title'] as String,
  subtitle: json['subtitle'] as String,
  secondSubtitle: json['secondSubtitle'] as String,
  description: json['description'] as String,
  thumbnails: (json['thumbnails'] as List<dynamic>)
      .map((e) => YTThumbnail.fromJson(e as Map<String, dynamic>))
      .toList(),
  playEndpoint: json['playEndpoint'] as Map<String, dynamic>?,
  radioEndpoint: json['radioEndpoint'] as Map<String, dynamic>?,
  shuffleEndpoint: json['shuffleEndpoint'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$YTPageHeaderToJson(YTPageHeader instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'secondSubtitle': instance.secondSubtitle,
      'description': instance.description,
      'thumbnails': instance.thumbnails,
      'playEndpoint': instance.playEndpoint,
      'radioEndpoint': instance.radioEndpoint,
      'shuffleEndpoint': instance.shuffleEndpoint,
    };
