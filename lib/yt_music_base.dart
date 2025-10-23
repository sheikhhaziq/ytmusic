import 'package:ytmusic/client.dart';
import 'package:ytmusic/models/browse_page.dart';
import 'package:ytmusic/models/chip_page.dart';
import 'package:ytmusic/models/item_continuation.dart';
import 'package:ytmusic/models/models.dart';
import 'package:ytmusic/models/playlist.dart';
import 'package:ytmusic/models/podcast.dart';
import 'package:ytmusic/models/search.dart';
import 'package:ytmusic/parsers/album.dart';
import 'package:ytmusic/parsers/artist.dart';
import 'package:ytmusic/parsers/browse.dart';
import 'package:ytmusic/parsers/chip.dart';
import 'package:ytmusic/parsers/home_page.dart';
import 'package:ytmusic/parsers/item_continuation.dart';
import 'package:ytmusic/parsers/playlist.dart';
import 'package:ytmusic/parsers/podcast.dart';
import 'package:ytmusic/parsers/search.dart';
import 'package:ytmusic/utils/isolate.dart';

class YTMusic {
  late YTClient _client;
  void Function(YTConfig)? onConfigUpdate;


  YTMusic({String? cookies, YTConfig? config,this.onConfigUpdate}) {
    _client = YTClient(
      config ?? YTConfig(visitorData: "", language: "en", location: "IN"),
      cookies,
      onConfigUpdate:onConfigUpdate 
    );
  }

  void setConfig(YTConfig config){
    _client.config=config;
  }

  static Future<YTConfig?> fetchConfig() => YTClient.fetchConfig();

  Future<YTItemContinuation> getContinuationItems({
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

  Future<YTHomePage> getHomePage({int limit = 1}) async {
    final data = await _client.constructRequest(
      "browse",
      body: {"browseId": 'FEmusic_home'},
    );
    final home = await runInIsolate(HomePageParser.parse, data);
    while (home.sections.length < limit && home.continuation != null) {
      final conti = await getHomePageContinuation(
        continuation: home.continuation!,
      );
      home.sections = [...home.sections, ...conti.sections];
      home.continuation = conti.continuation;
    }
    return home;
  }

  Future<YTHomeContinuationPage> getHomePageContinuation({
    required String continuation,
  }) async {
    final data = await _client.constructRequest(
      "browse",
      body: {"browseId": "FEmusic_home"},
      query: {"continuation": continuation},
    );

    return runInIsolate(HomePageParser.parseContinuation, data);
  }

  Future<YTChipPage> getChipPage({
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

  Future<YTChipContinuationPage> getChipPageContinuation({
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

  Future<YTBrowsePage> browseMore({required Map<String, dynamic> body}) async {
    final data = await _client.constructRequest("browse", body: body);
    return runInIsolate(BrowseParser.parse, data);
  }

  Future<YTPlaylistPage> getPlaylist({
    required Map<String, dynamic> body,
  }) async {
    final data = await _client.constructRequest("browse", body: body);
    return runInIsolate(PlaylistParser.parse, data);
  }

  Future<List<YTSectionItem>> getNextSongs({
    required Map<String, dynamic> body,
  }) async {
    final data = await _client.constructRequest("next", body: body);
    return PlaylistParser.parseSongs(data);
  }

  Future<YTPlaylistContinuationPage> getPlaylistSectionContinuation({
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

  Future<YTAlbumPage> getAlbum({required Map<String, dynamic> body}) async {
    final data = await _client.constructRequest("browse", body: body);
    return AlbumParser.parse(data);
  }

  Future<YTArtistPage> getArtist({required Map<String, dynamic> body}) async {
    final data = await _client.constructRequest("browse", body: body);
    return ArtistParser.parse(data);
  }

  Future<YTPodcastPage> getPodcast({required Map<String, dynamic> body}) async {
    final data = await _client.constructRequest("browse", body: body);
    return PodcastParser.parse(data);
  }

  Future getPodcastContinuation({
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

  Future getSearch({required String query}) async {
    final data = await _client.constructRequest(
      "search",
      body: {"query": query},
    );
    return SearchParser.parse(data);
  }
}
