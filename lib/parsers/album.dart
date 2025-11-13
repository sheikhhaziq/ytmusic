import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class AlbumParser {
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
}
