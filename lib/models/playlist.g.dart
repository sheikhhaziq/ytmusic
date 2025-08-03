// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YTPlaylistPage _$YTPlaylistPageFromJson(Map<String, dynamic> json) =>
    YTPlaylistPage(
      header: YTPageHeader.fromJson(json['header'] as Map<String, dynamic>),
      sections: (json['sections'] as List<dynamic>)
          .map((e) => YTSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      continuation: json['continuation'] as String?,
    );

Map<String, dynamic> _$YTPlaylistPageToJson(YTPlaylistPage instance) =>
    <String, dynamic>{
      'header': instance.header,
      'sections': instance.sections,
      'continuation': instance.continuation,
    };

YTPlaylistContinuationPage _$YTPlaylistContinuationPageFromJson(
  Map<String, dynamic> json,
) => YTPlaylistContinuationPage(
  sections: (json['sections'] as List<dynamic>)
      .map((e) => YTSection.fromJson(e as Map<String, dynamic>))
      .toList(),
  continuation: json['continuation'] as String?,
);

Map<String, dynamic> _$YTPlaylistContinuationPageToJson(
  YTPlaylistContinuationPage instance,
) => <String, dynamic>{
  'sections': instance.sections,
  'continuation': instance.continuation,
};
