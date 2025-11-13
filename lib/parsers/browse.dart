import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class BrowseParser {
  static Page parse(data) {
    bool hasHeader = true;
    if (data['contents']['singleColumnBrowseResultsRenderer'] != null) {
      hasHeader = false;
    }

    final contentsData = hasHeader
        ? traverseList(data, [
            'contents',
            'twoColumnBrowseResultsRenderer',
            'secondaryContents',
            'sectionListRenderer',
            'contents',
          ])
        : traverseList(data, [
            'contents',
            'singleColumnBrowseResultsRenderer',
            'tabs',
            'tabRenderer',
            'content',
            'sectionListRenderer',
            'contents',
          ]);

    final header = traverse(data, [
      'contents',
      'twoColumnBrowseResultsRenderer',
      'tabs',
      'tabRenderer',
      'content',
      'sectionListRenderer',
      'contents',
      'musicResponsiveHeaderRenderer',
    ]);

    return Page(
      header: hasHeader ? Parser.parsePageHeader(header) : null,
      sections: contentsData
          .map((json) => Parser.parseSection(json))
          .where((e) => e != null)
          .toList()
          .cast<Section>(),
      provider: DataProvider.ytmusic,
    );
  }
}
