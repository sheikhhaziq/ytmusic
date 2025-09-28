// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YTSection _$YTSectionFromJson(Map<String, dynamic> json) => YTSection(
  title: json['title'] as String,
  strapline: json['strapline'] as String?,
  trailing: json['trailing'] == null
      ? null
      : YTSectionTrailing.fromJson(json['trailing'] as Map<String, dynamic>),
  items: (json['items'] as List<dynamic>)
      .map((e) => YTSectionItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  continuation: json['continuation'] as String?,
  type:
      $enumDecodeNullable(_$YTSectionTypeEnumMap, json['type']) ??
      YTSectionType.row,
);

Map<String, dynamic> _$YTSectionToJson(YTSection instance) => <String, dynamic>{
  'title': instance.title,
  'strapline': instance.strapline,
  'trailing': instance.trailing?.toJson(),
  'items': instance.items.map((s) => s.toJson()).toList(),
  'type': _$YTSectionTypeEnumMap[instance.type]!,
  'continuation': instance.continuation,
};

const _$YTSectionTypeEnumMap = {
  YTSectionType.row: 'row',
  YTSectionType.singleColumn: 'singleColumn',
  YTSectionType.multiColumn: 'multiColumn',
  YTSectionType.grid: 'grid',
};

YTSectionTrailing _$YTSectionTrailingFromJson(Map<String, dynamic> json) =>
    YTSectionTrailing(
      text: json['text'] as String,
      endpoint: json['endpoint'] as Map<String, dynamic>,
      isPlayable: json['isPlayable'] as bool,
    );

Map<String, dynamic> _$YTSectionTrailingToJson(YTSectionTrailing instance) =>
    <String, dynamic>{
      'text': instance.text,
      'endpoint': instance.endpoint,
      'isPlayable': instance.isPlayable,
    };

YTSectionItem _$YTSectionItemFromJson(Map<String, dynamic> json) =>
    YTSectionItem(
      title: json['title'] as String,
      id: json['id'] as String,
      playlistId: json['playlistId'] as String?,
      desctiption: json['desctiption'] as String?,
      thumbnails: (json['thumbnails'] as List<dynamic>)
          .map((e) => YTThumbnail.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtitle: json['subtitle'] as String?,
      type: $enumDecode(_$YTSectionItemTypeEnumMap, json['type']),
      artists:
          (json['artists'] as List<dynamic>?)
              ?.map((e) => YTArtist.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      album: json['album'] == null
          ? null
          : YTAlbum.fromJson(json['album'] as Map<String, dynamic>),
      shuffleEndpoint: json['shuffleEndpoint'] as Map<String, dynamic>?,
      radioEndpoint: json['radioEndpoint'] as Map<String, dynamic>?,
      endpoint: json['endpoint'] as Map<String, dynamic>?,
      isRectangle: json['isRectangle'] as bool? ?? false,
    );

Map<String, dynamic> _$YTSectionItemToJson(YTSectionItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'playlistId': instance.playlistId,
      'subtitle': instance.subtitle,
      'desctiption': instance.desctiption,
      'id': instance.id,
      'thumbnails': instance.thumbnails
          .map((thumbnail) => thumbnail.toJson())
          .toList(),
      'type': _$YTSectionItemTypeEnumMap[instance.type]!,
      'artists': instance.artists.map((artist) => artist.toJson()).toList(),
      'album': instance.album,
      'endpoint': instance.endpoint,
      'shuffleEndpoint': instance.shuffleEndpoint,
      'radioEndpoint': instance.radioEndpoint,
      'isRectangle': instance.isRectangle,
    };

const _$YTSectionItemTypeEnumMap = {
  YTSectionItemType.episode: 'episode',
  YTSectionItemType.album: 'album',
  YTSectionItemType.playlist: 'playlist',
  YTSectionItemType.podcast: 'podcast',
  YTSectionItemType.song: 'song',
  YTSectionItemType.video: 'video',
  YTSectionItemType.artist: 'artist',
  YTSectionItemType.unknown: 'unknown',
};
