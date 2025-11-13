import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class ArtistParser {
  static Page parse(data) {
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

    return Page(
      header: Parser.parsePageHeader(header),
      sections: sectionsdata
          .map((json) => Parser.parseSection(json))
          .where((e) => e != null)
          .toList()
          .cast<Section>(),
      continuation: null,
      provider: DataProvider.ytmusic,
    );
  }
}
