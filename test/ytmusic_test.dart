import 'package:flutter_test/flutter_test.dart';
import 'package:ytmusic/models/browse_page.dart';
import 'package:ytmusic/models/chip_page.dart';
import 'package:ytmusic/models/item_continuation.dart';
import 'package:ytmusic/models/playlist.dart';
import 'package:ytmusic/models/podcast.dart';
import 'package:ytmusic/models/search.dart';

import 'package:ytmusic/ytmusic.dart';

void main() async {
  final config = await YTMusic.fetchConfig();
  final ytmusic = YTMusic(config: config);

  test('Fetches Continuation Item', () async {
    final res = await ytmusic.getContinuationItems(
      body: {
        "browseId": "MPSPPLhPeiukKHCHFRwKvbfYD0Z8DnsIc6lYEb",
        "browseEndpointContextSupportedConfigs": {
          "browseEndpointContextMusicConfig": {
            "pageType": "MUSIC_PAGE_TYPE_PODCAST_SHOW_DETAIL_PAGE",
          },
        },
      },
      continuation:
          "4qmFsgJmEiZNUFNQUExub3BJX21RTlRwOWJZbTZaZ19WVE5fSC04NlhFcjhsbBo8ZWg1UVZEcERSMUZwUlVSck1FOVZUa0pSVlZVMVQwVk5lRTFFUmtOT1ZFR1NBUU1JMlFqYUNBUUlBaEFC",
    );
    expect(res, isA<YTItemContinuation>());
  });

  test('Fetches Homepage Data', () async {
    final res = await ytmusic.getHomePage(limit: 5);
    expect(res, isA<YTHomePage>());
  });

  test('Fetches HomePage continuation', () async {
    final res = await ytmusic.getHomePageContinuation(
      continuation:
          "4qmFsgKhAhIMRkVtdXNpY19ob21lGpACQ0F4Nnh3RkhUbEJaTm5OcWVIZFpORVJYYjBWQ1EyNDRTMHBJYkRCWU0wSm9XakpXWm1NeU5XaGpTRTV2WWpOU1ptSllWbnBoVjA1bVkwZEdibHBXT1hsYVYyUndZakkxYUdKQ1NXWlpla0pTVmxoR1JGSlhkRTVpYTFaWFVWVlNSR0pZV25oalZtaHFXVzVCZVZadFdqUlNSMlJUWVhodk1sUllWbnBoVjA1RllWaE9hbUl6V214amJteFJXVmRrYkZVeVZubGtiV3hxV2xNeFNGcFlVa2xpTWpGc1ZVZEdibHBSUVVKQlIxWjFRVUZHU2xSblFVSlRWVFJCUVZGRlJDMXdla2gyVVd0RFEwRXc%3D",
    );
    expect(res, isA<YTHomeContinuationPage>());
  });

  test('Fetches Chip Screen', () async {
    final res = await ytmusic.getChipPage(
      body: {
        "browseId": "FEmusic_home",
        "params":
            "ggNCSgQIDBADSgQIBxABSgQIBBABSgQICRABSgQIDRABSgQIAxABSgQICBABSgQIDhABSgQIChABSgQIBhABSgQIBRAB",
      },
    );
    expect(res, isA<YTChipPage>());
  });

  test('Fetches Chip Screen continuation', () async {
    final res = await ytmusic.getChipPageContinuation(
      body: {
        "browseId": "FEmusic_home",
        "params":
            "ggNCSgQIDBADSgQIBxABSgQIBBABSgQICRABSgQIDRABSgQIAxABSgQICBABSgQIDhABSgQIChABSgQIBhABSgQIBRAB",
      },
      continuation:
          "4qmFsgKJAxIMRkVtdXNpY19ob21lGvgCQ0FONnl3RkhTMUJCYWpoeVJIWktRVVJYYjFGQ1EyOUZRa05wVWpWa1JqbDNXVmRrYkZnelRuVlpXRUo2WVVjNU1GZ3lNVEZqTW14cVdETkNhRm95Vm1aamJWWnVZVmM1ZFZsWGQxTklNR3Q1VVROV2VGZEZkRzFVYlRreldWVkdSVkV5TVRKaldFWlpXVEpLZVZaNmFESmpSbXgyVlcxellVOUZNVEZqTW14cVVrZHNlbGt5T1RKYVdFbzFWVWRHYmxwV1RteGpibHB3V1RKVmRGSXlWakJUUnpsMFdsWkNhRm95VlVGQlVVSnNZbWRCUWxOVk5FRkJWV3hQUVVGRlFrRjNSVTB0Y0hwSWRsRnJRME5CVVlJRFFrb0VDQXdRQTBvRUNBY1FBVW9FQ0FRUUFVb0VDQWtRQVVvRUNBMFFBVW9FQ0FNUUFVb0VDQWdRQVVvRUNBNFFBVW9FQ0FvUUFVb0VDQVlRQVVvRUNBVVFBUSUzRCUzRA%3D%3D",
    );
    expect(res, isA<YTChipContinuationPage>());
  });

  test('Browse More songs', () async {
    final res = await ytmusic.browseMore(
      body: {"browseId": "VLPL4fGSI1pDJn5oibdgJt8Hy0-dr2B7kSs2", "browseEndpointContextSupportedConfigs": {"browseEndpointContextMusicConfig": {"pageType": "MUSIC_PAGE_TYPE_PLAYLIST"}}},
    );
    expect(res, isA<YTBrowsePage>());
  });

  test('Get Playlist Page', () async {
    final res = await ytmusic.getPlaylist(
      body: {
        "browseId": "VLRDCLAK5uy_lBNUteBRencHzKelu5iDHwLF6mYqjL-JU",
        "browseEndpointContextSupportedConfigs": {
          "browseEndpointContextMusicConfig": {
            "pageType": "MUSIC_PAGE_TYPE_PLAYLIST",
          },
        },
      },
    );
    expect(res, isA<YTPlaylistPage>());
  });

  test("Get playlist Songs", () async {
    final res = await ytmusic.getNextSongs(
      body: {
        "videoId": "rvGbTsXPu9A",
        "playlistId": "RDAMVMrvGbTsXPu9A",
        "params": "wAEB",
        "loggingContext": {
          "vssLoggingContext": {
            "serializedContextData": "GhFSREFNVk1ydkdiVHNYUHU5QQ%3D%3D",
          },
        },
        "watchEndpointMusicSupportedConfigs": {
          "watchEndpointMusicConfig": {
            "musicVideoType": "MUSIC_VIDEO_TYPE_ATV",
          },
        },
      },
    );
    expect(res, isA<List<YTItem>>());
  });
  test('Get Playlist continuation Page', () async {
    final res = await ytmusic.getPlaylistSectionContinuation(
      body: {
        "browseId": "VLRDCLAK5uy_lBNUteBRencHzKelu5iDHwLF6mYqjL-JU",
        "browseEndpointContextSupportedConfigs": {
          "browseEndpointContextMusicConfig": {
            "pageType": "MUSIC_PAGE_TYPE_PLAYLIST",
          },
        },
      },
      continuation:
          "4qmFsgI9Ei1WTFJEQ0xBSzV1eV9sQk5VdGVCUmVuY0h6S2VsdTVpREh3TEY2bVlxakwtSlUaDGtnRURDTTBHOEFFQQ%3D%3D",
    );
    expect(res, isA<YTPlaylistContinuationPage>());
  });

  test('Get Album Page', () async {
    final res = await ytmusic.getAlbum(
      body: {
        "browseId": "MPREb_mz3GHKjUv6q",
        "params":
            "ggMrGilPTEFLNXV5X25kQkpFVC1qV0xhMnJ1YTFwams1S1JpZkZsa0Q2VENkdw%3D%3D",
        "browseEndpointContextSupportedConfigs": {
          "browseEndpointContextMusicConfig": {
            "pageType": "MUSIC_PAGE_TYPE_ALBUM",
          },
        },
      },
    );
    expect(res, isA<YTAlbumPage>());
  });

  test('Get Artist Page', () async {
    final res = await ytmusic.getArtist(
      body: {
        "browseId": "UCedvOgsKFzcK3hA5taf3KoQ",
        "browseEndpointContextSupportedConfigs": {
          "browseEndpointContextMusicConfig": {
            "pageType": "MUSIC_PAGE_TYPE_ARTIST",
          },
        },
      },
    );
    expect(res, isA<YTArtistPage>());
  });

  test('Get Podcast Page', () async {
    final res = await ytmusic.getPodcast(
      body: {
        "browseId": "MPSPPLhPeiukKHCHFRwKvbfYD0Z8DnsIc6lYEb",
        "browseEndpointContextSupportedConfigs": {
          "browseEndpointContextMusicConfig": {
            "pageType": "MUSIC_PAGE_TYPE_PODCAST_SHOW_DETAIL_PAGE",
          },
        },
      },
    );
    expect(res, isA<YTPodcastPage>());
  });

  test('Get Podcast Page Continuation', () async {
    final res = await ytmusic.getPodcastContinuation(
      body: {
        "browseId": "MPSPPLhPeiukKHCHFRwKvbfYD0Z8DnsIc6lYEb",
        "browseEndpointContextSupportedConfigs": {
          "browseEndpointContextMusicConfig": {
            "pageType": "MUSIC_PAGE_TYPE_PODCAST_SHOW_DETAIL_PAGE",
          },
        },
      },
      continuation:
          "4qmFsgJuEiZNUFNQUExoUGVpdWtLSENIRlJ3S3ZiZllEMFo4RG5zSWM2bFlFYhpEZWg5UVZEcERTa0ZFU1doQk1WSkVWWHBTYWtwR1VUQlpNRTFWU1ROT2VsVXhrZ0VEQ05rSTJnZ0VDQUlRQVElM0QlM0Q%3D",
    );
    expect(res, isA<YTPodcastContinuationPage>());
  });

  test('Get Search Suggestions', () async {
    final res = await ytmusic.getSearchSuggestions(query: "za");
    expect(res, isA<YTSearchSuggestions>());
  });
  test('Get Search Page', () async {
    final res = await ytmusic.getSearch(query: "kahani suno 2.0");
    expect(res, isA<YTSearchPage>());
  });
  test('Get Explore Page', () async {
    final res = await ytmusic.getExplore();
    // print(res.length);
    expect(res, isA<List<YTSection>>());
  });
}
