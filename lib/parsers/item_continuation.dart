import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/models/item_continuation.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class ItemContinuationParser {
  static SectionItemContinuation parse(data) {
    final head = traverse(data, [
      'continuationContents',
      'musicShelfContinuation',
    ]);
    return SectionItemContinuation(
      items: traverseList(head, ["contents"])
          .map((json) => Parser.parseSectionItem(json))
          .where((e) => e != null)
          .toList()
          .cast<SectionItem>(),
      continuation: traverseString(head, [
        'continuations',
        'nextContinuationData',
        'continuation',
      ]),
    );
  }
}
