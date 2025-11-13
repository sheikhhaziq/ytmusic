import 'package:gyawun_shared/gyawun_shared.dart';

SectionItem? getSectionItem(
  SectionItemType type, {
  required String id,
  required String title,
  required String subtitle,
  required String description,
  required String playlistId,
  required List<Thumbnail> thumbnails,
  required Album? album,
  required List<Artist> artists,

  required Map<String, dynamic> endpoint,
  Map<String, dynamic>? radioEndpoint,
  Map<String, dynamic>? shuffleEndpoint,
}) {
  switch (type) {
    case SectionItemType.song:
    case SectionItemType.video:
    case SectionItemType.episode:
      return PlayableItem(
        id: id,
        thumbnails: thumbnails,
        album: album,
        artists: artists,
        subtitle: subtitle,
        radioEndpoint: radioEndpoint,
        shuffleEndpoint: shuffleEndpoint,
        title: title,
        endpoint: endpoint,
        provider: DataProvider.ytmusic,
        type: type,
        downloadItems: null,
      );

    default:
      return SectionItem(
        id: id,
        title: title,
        subtitle: subtitle,
        artists: artists,
        thumbnails: thumbnails,
        endpoint: endpoint,
        provider: DataProvider.ytmusic,
        type: type,
        radioEndpoint: radioEndpoint,
        shuffleEndpoint: shuffleEndpoint,
      );
  }
}
