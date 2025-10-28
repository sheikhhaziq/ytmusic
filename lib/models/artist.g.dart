// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YTArtistBasic _$YTArtistBasicFromJson(Map<String, dynamic> json) =>
    YTArtistBasic(
      title: YTArtistBasic._extractTitle(json, 'title') as String,
      id: YTArtistBasic._extractBrowseId(json, 'id') as String,
      endpoint:
          YTArtistBasic._extractEndpoint(json, 'endpoint')
              as Map<String, dynamic>,
    );

Map<String, dynamic> _$YTArtistBasicToJson(YTArtistBasic instance) =>
    <String, dynamic>{
      'title': instance.title,
      'id': instance.id,
      'endpoint': instance.endpoint,
    };
