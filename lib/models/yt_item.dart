import 'package:flutter/cupertino.dart';
import 'package:ytmusic/enums/section_item_type.dart';
import 'package:ytmusic/mixins/mixins.dart';
import 'package:ytmusic/models/album.dart';
import 'package:ytmusic/models/artist.dart';
import 'package:ytmusic/models/thumbnail.dart';


@immutable
abstract class YTItem {
  final String id;
  final String title;
  final String subtitle;
  final Map<String, dynamic> endpoint;

  const YTItem({required this.id,required this.title,required this.subtitle, required this.endpoint,});

  static YTItem? itemFrom(
    YTItemType type, {
    required String id,
    required String title,
    required String subtitle,
    required String description,
    required String playlistId,
    required List<YTThumbnail> thumbnails,
    required YTAlbumBasic? album,
    required List<YTArtistBasic> artists,

    required Map<String, dynamic> endpoint,
    Map<String, dynamic>? radioEndpoint,
    Map<String, dynamic>? shuffleEndpoint,
  }) {
    switch(type){
      case YTItemType.song:
        return YTSong(
          id: id,
          playlistId: playlistId,
          thumbnails: thumbnails,
          album: album,
          artists: artists,
          subtitle: subtitle,
          radioEndpoint: radioEndpoint,
          title: title,
          endpoint: endpoint,
        );
      case YTItemType.video:
        return YTVideo(
          id: id,
          playlistId: playlistId,
          thumbnails: thumbnails,
          album: album,
          artists: artists,
          subtitle: subtitle,
          radioEndpoint: radioEndpoint,
          title: title,
          endpoint: endpoint,
        );
      case YTItemType.artist:
        return YTArtist(
          id: id,
          thumbnails: thumbnails,
          subtitle: subtitle,
          radioEndpoint: radioEndpoint,
          title: title,
          endpoint: endpoint,
        );
      case YTItemType.playlist:
        return YTPlaylist(
          id: id,
          title: title,
          thumbnails: thumbnails,
          artists: artists,
          subtitle: subtitle,
          radioEndpoint: radioEndpoint,
          shuffleEndpoint: shuffleEndpoint,
          endpoint: endpoint,
        );
      case YTItemType.album:
        return YTAlbum(
          id: id,
          title: title,
          thumbnails: thumbnails,
          artists: artists,
          subtitle: subtitle,
          endpoint: endpoint,
          shuffleEndpoint: shuffleEndpoint,
          radioEndpoint: radioEndpoint,
        );
      case YTItemType.podcast:
        return YTPodcast(
          id: id,
          title: title,
          subtitle: subtitle,
          thumbnails: thumbnails,
          endpoint: endpoint,
        );
      case YTItemType.episode:
        return YTEpisode(
          id: id,
          title: title,
          subtitle: subtitle,
          description: description,
          thumbnails: thumbnails,
          endpoint: endpoint,
        );
      default:
      print(title);
       return null;
    }
  }
}

class YTButtonItem extends YTItem {
 const YTButtonItem({required super.title, required super.endpoint,super.subtitle="", required super.id});
}

class YTSong extends YTItem with HasPlaylistId, HasAlbum,HasArtists,HasRadioEndpoint,HasThumbnail {
  @override
  final String playlistId;
  @override
  final List<YTThumbnail> thumbnails;
  @override
  final YTAlbumBasic? album;
  @override
  final List<YTArtistBasic> artists;
  @override
  final Map<String, dynamic>? radioEndpoint;

  const YTSong({
    required super.id,
    required this.playlistId,
    required this.thumbnails,
    required this.album,
    required this.artists,
    required super.subtitle,
    this.radioEndpoint,
    required super.title,
    required super.endpoint,
  });

}

class YTVideo extends YTItem with HasPlaylistId, HasAlbum,HasArtists,HasRadioEndpoint,HasThumbnail {
  @override
  final String playlistId;
  @override
  final List<YTThumbnail> thumbnails;
  @override
  final YTAlbumBasic? album;
  @override
  final List<YTArtistBasic> artists;
  @override
  final Map<String, dynamic>? radioEndpoint;

  const YTVideo({
    required super.id,
    required this.playlistId,
    required this.thumbnails,
    required this.album,
    required this.artists,
    required super.subtitle,
    this.radioEndpoint,
    required super.title,
    required super.endpoint,
  });
}

class YTArtist extends YTItem with HasRadioEndpoint,HasThumbnail{
  @override
  final List<YTThumbnail> thumbnails;
  @override
  final Map<String, dynamic>? radioEndpoint;

  const YTArtist({
    required super.id,
    required this.thumbnails,
    required super.subtitle,
    this.radioEndpoint,
    required super.title,
    required super.endpoint,
  });

}

class YTPlaylist extends YTItem with  HasArtists,HasRadioEndpoint,HasShuffleEndpoint,HasThumbnail {
  @override
  final List<YTThumbnail> thumbnails;
  @override
  final List<YTArtistBasic> artists;
  @override
  final Map<String, dynamic>? radioEndpoint;
  @override
  final Map<String, dynamic>? shuffleEndpoint;

  const YTPlaylist({
    required super.id,
    required super.title,
    required this.thumbnails,
    required this.artists,
    required super.subtitle,
    this.radioEndpoint,
    this.shuffleEndpoint,
    required super.endpoint,
  });

}

class YTAlbum extends YTItem with  HasArtists,HasRadioEndpoint,HasShuffleEndpoint,HasThumbnail {
  @override
  final List<YTThumbnail> thumbnails;
  @override
  final List<YTArtistBasic> artists;
  @override
  final Map<String, dynamic>? radioEndpoint;
  @override
  final Map<String, dynamic>? shuffleEndpoint;

  const YTAlbum({
    required super.id,
    required super.title,
    required this.thumbnails,
    required this.artists,
    required super.subtitle,
    this.radioEndpoint,
    this.shuffleEndpoint,
    required super.endpoint,
  });

}

class YTPodcast extends YTItem  with HasThumbnail{
  @override
  final List<YTThumbnail> thumbnails;


  const YTPodcast({
    required super.id,
    required super.title,
    required super.subtitle,
    required this.thumbnails,
    required super.endpoint,
  });
}


class YTEpisode extends YTItem with HasThumbnail, HasDescription{
  @override
  final String description;
  @override
  final List<YTThumbnail> thumbnails;

  const YTEpisode({
    required super.id,
    required super.title,
    required super.subtitle,
    required this.description,
    required this.thumbnails,
    required super.endpoint,
  });
}
