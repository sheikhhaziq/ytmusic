import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';
import 'package:ytmusic/ytmusic.dart';

class AlbumParser {
  static YTAlbumPage parse(data) {
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

    return YTAlbumPage(
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
}
