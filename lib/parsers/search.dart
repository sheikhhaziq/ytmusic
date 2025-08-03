import 'package:ytmusic/models/search.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';
import 'package:ytmusic/ytmusic.dart';

class SearchParser {
  static parse(data) {
    final tabs = traverseList(data, [
      "contents",
      "tabbedSearchResultsRenderer",
      "tabs",
    ]);
    final contentsdata = traverseList(tabs[0], [
      "tabRenderer",
      "content",
      "sectionListRenderer",
      "contents",
    ]);
    return YTSearchPage(
      sections: contentsdata
          .map((Parser.parseSection))
          .where((e) => e != null)
          .toList()
          .cast<YTSection>(),
    );
  }

  static YTSearchSuggestions parseSuggestions(data) {
    final textSuggestionsData = traverseList(data?["contents"]?[0], [
      "searchSuggestionsSectionRenderer",
      "contents",
    ]);
    final sectionItemSuggestions = traverseList(data?["contents"]?[1], [
      "searchSuggestionsSectionRenderer",
      "contents",
    ]);
    return YTSearchSuggestions(
      textItems: textSuggestionsData.map(_textSuggestions).toList(),
      sectionItems: sectionItemSuggestions
          .map((e) => Parser.parseSectionItem(e))
          .where((e) => e != null)
          .toList()
          .cast<YTSectionItem>(),
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
