import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/models/continuation_page.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class ChipPageParser {
  static Page parse(data) {
    final head = traverse(data, [
      'contents',
      'singleColumnBrowseResultsRenderer',
      'tabs',
      'tabRenderer',
      'content',
      'sectionListRenderer',
    ]); // [contents, continuations, trackingParams, header]

    final sectionsData = traverseList(head, ['contents']);
    final sections = sectionsData
        .map(Parser.parseSection)
        .where((section) => section != null)
        .toList()
        .cast<Section>();
    final continuations = traverseString(head['continuations'], [
      'continuation',
    ]);
    return Page(
      sections: sections,
      continuation: continuations,
      header: null,
      provider: DataProvider.ytmusic,
    );
  }

  static ContinuationPage parseContinuation(data) {
    // ["responseContext","contents","continuationContents","trackingParams","maxAgeStoreSeconds"]
    final home = traverse(data, [
      'continuationContents',
      'sectionListContinuation',
    ]);
    final continuation = traverseString(home, [
      'continuations',
      'continuation',
    ]);
    final sectionData = traverseList(home, ['contents']);
    final sections = sectionData
        .map((json) => Parser.parseSection(json))
        .toList()
        .cast<Section>();

    return ContinuationPage(sections: sections, continuation: continuation);
  }
}
