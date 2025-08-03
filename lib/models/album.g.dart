// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YTAlbum _$YTAlbumFromJson(Map<String, dynamic> json) => YTAlbum(
  title: YTAlbum._extractTitle(json, 'title') as String,
  id: YTAlbum._extractBrowseId(json, 'id') as String,
  endpoint: YTAlbum._extractEndpoint(json, 'endpoint') as Map<String, dynamic>,
);

Map<String, dynamic> _$YTAlbumToJson(YTAlbum instance) => <String, dynamic>{
  'title': instance.title,
  'id': instance.id,
  'endpoint': instance.endpoint,
};

YTAlbumPage _$YTAlbumPageFromJson(Map<String, dynamic> json) => YTAlbumPage(
  header: YTPageHeader.fromJson(json['header'] as Map<String, dynamic>),
  sections: (json['sections'] as List<dynamic>)
      .map((e) => YTSection.fromJson(e as Map<String, dynamic>))
      .toList(),
  continuation: json['continuation'] as String?,
);

Map<String, dynamic> _$YTAlbumPageToJson(YTAlbumPage instance) =>
    <String, dynamic>{
      'header': instance.header,
      'sections': instance.sections,
      'continuation': instance.continuation,
    };
