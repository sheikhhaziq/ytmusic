
import 'package:ytmusic/ytmusic.dart';


mixin HasPlaylistId on YTItem {
  String get playlistId;
}

mixin HasThumbnail on YTItem {
  List<YTThumbnail> get thumbnails;
}

mixin HasArtists on YTItem {
  List<YTArtistBasic> get artists;
}

mixin HasAlbum on YTItem {
  YTAlbumBasic? get album;
}

mixin HasRadioEndpoint on YTItem {
  Map<String, dynamic>? get radioEndpoint;
}

mixin HasShuffleEndpoint on YTItem {
  Map<String, dynamic>? get shuffleEndpoint;
}
mixin HasDescription on YTItem{
  String get description;
}