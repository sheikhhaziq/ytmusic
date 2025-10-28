// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YTAlbumBasic _$YTAlbumBasicFromJson(Map<String, dynamic> json) => YTAlbumBasic(
  title: YTAlbumBasic._extractTitle(json, 'title') as String,
  id: YTAlbumBasic._extractBrowseId(json, 'id') as String,
  endpoint:
      YTAlbumBasic._extractEndpoint(json, 'endpoint') as Map<String, dynamic>,
);

Map<String, dynamic> _$YTAlbumBasicToJson(YTAlbumBasic instance) =>
    <String, dynamic>{
      'title': instance.title,
      'id': instance.id,
      'endpoint': instance.endpoint,
    };
