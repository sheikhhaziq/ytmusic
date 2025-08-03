enum YTSectionItemType {
  episode,
  album,
  playlist,
  podcast,
  song,
  video,
  artist,
  unknown,
}

YTSectionItemType getSectionItemType(String? value) {
  switch (value) {
    case 'MUSIC_PAGE_TYPE_NON_MUSIC_AUDIO_TRACK_PAGE':
      return YTSectionItemType.episode;
    case 'MUSIC_PAGE_TYPE_ALBUM':
      return YTSectionItemType.album;
    case 'MUSIC_PAGE_TYPE_PLAYLIST':
      return YTSectionItemType.playlist;
    case 'MUSIC_PAGE_TYPE_PODCAST_SHOW_DETAIL_PAGE':
      return YTSectionItemType.podcast;
    case 'MUSIC_VIDEO_TYPE_ATV':
      return YTSectionItemType.song;
    case 'MUSIC_VIDEO_TYPE_OMV':
    case 'MUSIC_VIDEO_TYPE_UGC':
      return YTSectionItemType.video;
    case 'MUSIC_PAGE_TYPE_ARTIST':
      return YTSectionItemType.artist;
    default:
      return YTSectionItemType.unknown;
  }
}
