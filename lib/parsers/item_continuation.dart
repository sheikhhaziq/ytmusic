import 'package:ytmusic/models/item_continuation.dart';
import 'package:ytmusic/models/yt_item.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

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
          .cast<YTItem>(),
      continuation: traverseString(head, [
        'continuations',
        'nextContinuationData',
        'continuation',
      ]),
    );
  }
}
