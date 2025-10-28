import 'package:ytmusic/models/models.dart';
import 'package:ytmusic/models/playlist.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class PlaylistParser {
  static YTPlaylistPage parse(data) {
    final headerData = traverse(data, [
      'contents',
      'twoColumnBrowseResultsRenderer',
      'tabs',
      'tabRenderer',
      'content',
      'sectionListRenderer',
      'contents',
      'musicResponsiveHeaderRenderer',
    ]);
    final sectionsData = traverse(data, [
      'contents',
      'twoColumnBrowseResultsRenderer',
      'secondaryContents',
      'sectionListRenderer',
    ]);

    return YTPlaylistPage(
      header: Parser.parsePageHeader(headerData),
      sections: sectionsData['contents']
          .map((json) => Parser.parseSection(json))
          .where((e) => e != null)
          .toList()
          .cast<YTSection>(),
      continuation: traverseString(sectionsData, [
        'continuations',
        'continuation',
      ]),
    );
  }
  static List<YTItem> parseSongs(data){
    final items = data['contents']['singleColumnMusicWatchNextResultsRenderer']['tabbedRenderer']['watchNextTabbedResultsRenderer']['tabs'][0]['tabRenderer']['content']['musicQueueRenderer']['content']['playlistPanelRenderer']['contents'];
    return items.map((e) => Parser.parseSectionItem(e)).where((e) => e != null).toList().cast<YTItem>();
  }

  static YTPlaylistContinuationPage parseContinuation(data) {
    final sectionsData = traverseList(data, [
      'continuationContents',
      'sectionListContinuation',
      'contents',
    ]);
    return YTPlaylistContinuationPage(
      sections: sectionsData
          .map((json) => Parser.parseSection(json))
          .where((e) => e != null)
          .toList()
          .cast<YTSection>(),
      continuation: traverseString(data, [
        'continuationContents',
        'musicShelfContinuation',
        'continuations',
        'nextContinuationData',
        'continuation',
      ]),
    );
  }
}
