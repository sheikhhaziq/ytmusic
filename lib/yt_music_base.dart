import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/client.dart';
import 'package:ytmusic/models/continuation_page.dart';
import 'package:ytmusic/models/item_continuation.dart';
import 'package:ytmusic/models/models.dart';
import 'package:ytmusic/models/search.dart';
import 'package:ytmusic/parsers/album.dart';
import 'package:ytmusic/parsers/artist.dart';
import 'package:ytmusic/parsers/browse.dart';
import 'package:ytmusic/parsers/chip.dart';
import 'package:ytmusic/parsers/explore.dart';
import 'package:ytmusic/parsers/home_page.dart';
import 'package:ytmusic/parsers/item_continuation.dart';
import 'package:ytmusic/parsers/playlist.dart';
import 'package:ytmusic/parsers/podcast.dart';
import 'package:ytmusic/parsers/search.dart';
import 'package:ytmusic/utils/isolate.dart';

class YTMusic {
  late YTClient _client;
  void Function(YTConfig)? onConfigUpdate;

  YTMusic({
    String? cookies,
    String? cacheDatabasePath,
    YTConfig? config,
    this.onConfigUpdate,
  }) {
    _client = YTClient(
      config ?? YTConfig(visitorData: "", language: "en", location: "IN"),
      cookies,
      onConfigUpdate: onConfigUpdate,
      cacheDatabasePath: cacheDatabasePath,
    );
  }

  void setConfig(YTConfig config) {
    _client.config = config;
  }

  static Future<YTConfig?> fetchConfig() => YTClient.fetchConfig();

  Future<SectionItemContinuation> getContinuationItems({
    required Map<String, dynamic> body,
    required String continuation,
  }) async {
    final data = await _client.constructRequest(
      "browse",
      body: body,
      query: {"continuation": continuation},
    );
    return ItemContinuationParser.parse(data);
  }

  Future<Page> getHomePage({int limit = 1}) async {
    final data = await _client.constructRequest(
      "browse",
      body: {"browseId": 'FEmusic_home'},
    );

    // final home = await runInIsolate(HomePageParser.parse, data);
    final home = HomePageParser.parse(data);
    while (home.sections.length < limit && home.continuation != null) {
      final conti = await getHomePageContinuation(
        continuation: home.continuation!,
      );
      home.sections = [...home.sections, ...conti.sections];
      home.continuation = conti.continuation;
    }
    return home;
  }

  Future<ContinuationPage> getHomePageContinuation({
    required String continuation,
  }) async {
    final data = await _client.constructRequest(
      "browse",
      body: {"browseId": "FEmusic_home"},
      query: {"continuation": continuation},
    );

    // return runInIsolate(HomePageParser.parseContinuation, data);
    return HomePageParser.parseContinuation(data);
  }

  Future<Page> getChipPage({
    required Map<String, dynamic> body,
    int limit = 1,
  }) async {
    final data = await _client.constructRequest("browse", body: body);
    final chip = await runInIsolate(ChipPageParser.parse, data);
    while (chip.sections.length < limit && chip.continuation != null) {
      final conti = await getChipPageContinuation(
        body: body,
        continuation: chip.continuation!,
      );
      chip.sections = [...chip.sections, ...conti.sections];
      chip.continuation = conti.continuation;
    }
    return chip;
  }

  Future<ContinuationPage> getChipPageContinuation({
    required Map<String, dynamic> body,
    required String continuation,
  }) async {
    final data = await _client.constructRequest(
      "browse",
      body: body,
      query: {"continuation": continuation},
    );
    return runInIsolate(ChipPageParser.parseContinuation, data);
  }

  Future<Page> browseMore({required Map<String, dynamic> body}) async {
    final data = await _client.constructRequest("browse", body: body);
    return BrowseParser.parse(data);
  }

  Future<Page> getPlaylist({required Map<String, dynamic> body}) async {
    final data = await _client.constructRequest("browse", body: body);
    return runInIsolate(PlaylistParser.parse, data);
  }

  Future<List<SectionItem>> getNextSongs({
    required Map<String, dynamic> body,
  }) async {
    final data = await _client.constructRequest("next", body: body);
    return PlaylistParser.parseSongs(data);
  }

  Future<ContinuationPage> getPlaylistSectionContinuation({
    required Map<String, dynamic> body,
    required String continuation,
  }) async {
    final data = await _client.constructRequest(
      "browse",
      body: body,
      query: {"continuation": continuation},
    );
    return runInIsolate(PlaylistParser.parseContinuation, data);
  }

  Future<Page> getAlbum({required Map<String, dynamic> body}) async {
    final data = await _client.constructRequest("browse", body: body);
    if (data['contents'] == null) {
      throw Exception("Not Found");
    }
    return AlbumParser.parse(data);
  }

  Future<Page> getArtist({required Map<String, dynamic> body}) async {
    final data = await _client.constructRequest("browse", body: body);
    return ArtistParser.parse(data);
  }

  Future<Page> getPodcast({required Map<String, dynamic> body}) async {
    final data = await _client.constructRequest("browse", body: body);
    return PodcastParser.parse(data);
  }

  Future<ContinuationPage> getPodcastContinuation({
    required Map<String, dynamic> body,
    required String continuation,
  }) async {
    final data = await _client.constructRequest(
      "browse",
      body: body,
      query: {"continuation": continuation},
    );
    return PodcastParser.parseContinuation(data);
  }

  Future<YTSearchSuggestions> getSearchSuggestions({
    required String query,
  }) async {
    final data = await _client.constructRequest(
      "music/get_search_suggestions",
      body: {"input": query},
    );
    return SearchParser.parseSuggestions(data);
  }

  Future<Page> getSearch({required String query}) async {
    final data = await _client.constructRequest(
      "search",
      body: {"query": query},
    );
    return SearchParser.parse(data);
  }

  Future<List<Section>> getExplore() async {
    final data = await _client.constructRequest(
      "browse",
      body: {"browseId": "FEmusic_explore"},
    );
    return ExploreParser.parse(data);
  }
}
