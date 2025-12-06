import 'package:ytmusic/client.dart';
import 'package:ytmusic/mixins/album_mixin.dart';
import 'package:ytmusic/mixins/artist_mixin.dart';
import 'package:ytmusic/mixins/browse_mixin.dart';
import 'package:ytmusic/mixins/chip_page_mixin.dart';
import 'package:ytmusic/mixins/continuation_mixin.dart';
import 'package:ytmusic/mixins/explore_mixin.dart';
import 'package:ytmusic/mixins/home_mixin.dart';
import 'package:ytmusic/mixins/playist_mixin.dart';
import 'package:ytmusic/mixins/podcast_mixin.dart';
import 'package:ytmusic/mixins/search_mixin.dart';
import 'package:ytmusic/mixins/songs_mixin.dart';

class YTMusic extends YTClient
    with
        HomeMixin,
        ChipPageMixin,
        PlaylistMixin,
        AlbumMixin,
        PodcastMixin,
        SearchMixin,
        ExploreMixin,
        ArtistMixin,
        SongsMixin,
        BrowseMixin,
        ContinuationMixin {
  YTMusic({String? cookies, super.config, super.onIdUpdate});
}
