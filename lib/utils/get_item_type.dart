import 'package:gyawun_shared/gyawun_shared.dart';

SectionItemType getItemType(String? value) {
  switch (value) {
    case 'MUSIC_PAGE_TYPE_NON_MUSIC_AUDIO_TRACK_PAGE':
      return SectionItemType.episode;
    case 'MUSIC_PAGE_TYPE_ALBUM':
      return SectionItemType.album;
    case 'MUSIC_PAGE_TYPE_PLAYLIST':
      return SectionItemType.playlist;
    case 'MUSIC_PAGE_TYPE_PODCAST_SHOW_DETAIL_PAGE':
      return SectionItemType.podcast;
    case 'MUSIC_VIDEO_TYPE_ATV':
      return SectionItemType.song;
    case 'MUSIC_VIDEO_TYPE_OMV':
    case 'MUSIC_VIDEO_TYPE_UGC':
      return SectionItemType.video;
    case 'MUSIC_PAGE_TYPE_ARTIST':
      return SectionItemType.artist;
    default:
      return SectionItemType.unknown;
  }
}
