import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/models/continuation_page.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class PlaylistParser {
  static Page parse(data) {
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

    return Page(
      header: Parser.parsePageHeader(headerData),
      sections: sectionsData['contents']
          .map((json) => Parser.parseSection(json))
          .where((e) => e != null)
          .toList()
          .cast<Section>(),
      continuation: traverseString(sectionsData, [
        'continuations',
        'continuation',
      ]),
      provider: DataProvider.ytmusic,
    );
  }

  static List<SectionItem> parseSongs(data) {
    final items =
        data['contents']['singleColumnMusicWatchNextResultsRenderer']['tabbedRenderer']['watchNextTabbedResultsRenderer']['tabs'][0]['tabRenderer']['content']['musicQueueRenderer']['content']['playlistPanelRenderer']['contents'];
    return items
        .map((e) => Parser.parseSectionItem(e))
        .where((e) => e != null)
        .toList()
        .cast<SectionItem>();
  }

  static ContinuationPage parseContinuation(data) {
    final sectionsData = traverseList(data, [
      'continuationContents',
      'sectionListContinuation',
      'contents',
    ]);
    return ContinuationPage(
      sections: sectionsData
          .map((json) => Parser.parseSection(json))
          .where((e) => e != null)
          .toList()
          .cast<Section>(),
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
