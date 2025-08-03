import 'package:ytmusic/models/podcast.dart';
import 'package:ytmusic/models/section.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class PodcastParser {
  static YTPodcastPage parse(data) {
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
    return YTPodcastPage(
      header: Parser.parsePageHeader(headerData),
      sections: sectionsData['contents']
          .map((json) => Parser.parseSection(json))
          .where((e) => e != null)
          .toList()
          .cast<YTSection>(),
      continuation: null,
    );
  }

  static parseContinuation(data) {
    final sectionsData = traverseList(data, [
      'continuationContents',
      'musicShelfContinuation',
      'contents',
    ]);

    return YTPodcastContinuationPage(
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
