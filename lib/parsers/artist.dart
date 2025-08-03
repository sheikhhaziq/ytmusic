import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';
import 'package:ytmusic/ytmusic.dart';

class ArtistParser {
  static YTArtistPage parse(data) {
    // ["responseContext","contents","header","trackingParams"]
    final header = traverse(data, ['header', 'musicImmersiveHeaderRenderer']);

    final sectionsdata = traverseList(data, [
      "contents",
      "singleColumnBrowseResultsRenderer",
      "tabs",
      "tabRenderer",
      "content",
      "sectionListRenderer",
      "contents",
    ]);

    return YTArtistPage(
      header: Parser.parsePageHeader(header),
      sections: sectionsdata
          .map((json) => Parser.parseSection(json))
          .where((e) => e != null)
          .toList()
          .cast<YTSection>(),
      continuation: null,
    );
  }
}
