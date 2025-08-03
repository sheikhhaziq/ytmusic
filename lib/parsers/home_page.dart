import 'package:ytmusic/models/chip.dart';
import 'package:ytmusic/models/home_page.dart';
import 'package:ytmusic/models/section.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class HomePageParser {
  static YTHomePage parse(data) {
    final head = traverse(data, [
      'contents',
      'singleColumnBrowseResultsRenderer',
      'tabs',
      'tabRenderer',
      'content',
      'sectionListRenderer',
    ]); // [contents, continuations, trackingParams, header]
    final chipsData = traverseList(head, [
      'header',
      'chipCloudRenderer',
      'chips',
    ]);
    final sectionsData = traverseList(head, ['contents']);
    final chips = chipsData.map(_parseChips).toList();
    final sections = sectionsData
        .map(Parser.parseSection)
        .where((section) => section != null)
        .toList()
        .cast<YTSection>();
    final continuations = traverseString(head['continuations'], [
      'continuation',
    ]);
    return YTHomePage(
      chips: chips,
      sections: sections,
      continuation: continuations,
    );
  }

  static YTChip _parseChips(data) {
    final chipData = data['chipCloudChipRenderer'];
    return YTChip(
      title: traverseString(chipData, ['text', 'runs', 'text']) ?? "",
      endpoint: traverse(chipData, ['navigationEndpoint', 'browseEndpoint']),
    );
  }

  static YTHomeContinuationPage parseContinuation(data) {
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

    return YTHomeContinuationPage(
      sections: sections,
      continuation: continuation,
    );
  }
}
