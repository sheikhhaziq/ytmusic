import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/models/search.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class SearchParser {
  static Page parse(data) {
    final tabs = traverseList(data, [
      "contents",
      "tabbedSearchResultsRenderer",
      "tabs",
    ]);
    final sectionListRenderer = traverse(tabs[0], [
      "tabRenderer",
      "content",
      "sectionListRenderer",
    ]);
    final contentsdata = traverseList(sectionListRenderer, ["contents"]);
    final chipsData = traverseList(sectionListRenderer, [
      'header',
      'chipCloudRenderer',
      'chips',
    ]);
    return Page(
      chips: chipsData.map(Parser.parseChips).toList().cast<ChipItem>(),
      sections: contentsdata
          .map((Parser.parseSection))
          .where((e) => e != null)
          .toList()
          .cast<Section>(),
      header: null,
      provider: DataProvider.ytmusic,
    );
  }

  static YTSearchSuggestions parseSuggestions(data) {
    if (data?["contents"] == null) {
      return YTSearchSuggestions(textItems: [], sectionItems: []);
    }
    List? textSuggestionsData;
    List? sectionItemSuggestions;

    if (data?["contents"].isNotEmpty) {
      textSuggestionsData = traverseList(data?["contents"]?[0], [
        "searchSuggestionsSectionRenderer",
        "contents",
      ]);
    }
    if (data?["contents"].length > 1) {
      sectionItemSuggestions = traverseList(data?["contents"]?[1], [
        "searchSuggestionsSectionRenderer",
        "contents",
      ]);
    }

    return YTSearchSuggestions(
      textItems: textSuggestionsData?.map(_textSuggestions).toList() ?? [],
      sectionItems:
          sectionItemSuggestions
              ?.map((e) => Parser.parseSectionItem(e))
              .where((e) => e != null)
              .toList()
              .cast<SectionItem>() ??
          [],
    );
  }

  static String _textSuggestions(data) {
    return traverseList(data, [
      "searchSuggestionRenderer",
      "suggestion",
      "runs",
      "text",
    ]).join("");
  }
}
