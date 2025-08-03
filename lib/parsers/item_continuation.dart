import 'package:ytmusic/models/item_continuation.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';
import 'package:ytmusic/ytmusic.dart';

class ItemContinuationParser {
  static YTItemContinuation parse(data) {
    final head = traverse(data, [
      'continuationContents',
      'musicShelfContinuation',
    ]);
    return YTItemContinuation(
      items: traverseList(head, ["contents"])
          .map((json) => Parser.parseSectionItem(json))
          .where((e) => e != null)
          .toList()
          .cast<YTSectionItem>(),
      continuation: traverseString(head, [
        'continuations',
        'nextContinuationData',
        'continuation',
      ]),
    );
  }
}
