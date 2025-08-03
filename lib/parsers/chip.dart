import 'package:ytmusic/models/chip_page.dart';
import 'package:ytmusic/models/section.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class ChipPageParser {
  static YTChipPage parse(data) {
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
        .cast<YTSection>();
    final continuations = traverseString(head['continuations'], [
      'continuation',
    ]);
    return YTChipPage(sections: sections, continuation: continuations);
  }

  static YTChipContinuationPage parseContinuation(data) {
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
        .cast<YTSection>();

    return YTChipContinuationPage(
      sections: sections,
      continuation: continuation,
    );
  }
}
