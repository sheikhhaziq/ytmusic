// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YTArtist _$YTArtistFromJson(Map<String, dynamic> json) => YTArtist(
  title: YTArtist._extractTitle(json, 'title') as String,
  id: YTArtist._extractBrowseId(json, 'id') as String,
  endpoint: YTArtist._extractEndpoint(json, 'endpoint') as Map<String, dynamic>,
);

Map<String, dynamic> _$YTArtistToJson(YTArtist instance) => <String, dynamic>{
  'title': instance.title,
  'id': instance.id,
  'endpoint': instance.endpoint,
};

YTArtistPage _$YTArtistPageFromJson(Map<String, dynamic> json) => YTArtistPage(
  header: YTPageHeader.fromJson(json['header'] as Map<String, dynamic>),
  sections: (json['sections'] as List<dynamic>)
      .map((e) => YTSection.fromJson(e as Map<String, dynamic>))
      .toList(),
  continuation: json['continuation'] as String?,
);

Map<String, dynamic> _$YTArtistPageToJson(YTArtistPage instance) =>
    <String, dynamic>{
      'header': instance.header,
      'sections': instance.sections,
      'continuation': instance.continuation,
    };
