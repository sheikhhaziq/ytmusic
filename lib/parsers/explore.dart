import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class ExploreParser {
  static List<Section> parse(data) {
    final sections = traverseList(data['contents'], [
      'tabs',
      'tabRenderer',
      'content',
      'sectionListRenderer',
      'contents',
    ]);
    return sections
        .map(Parser.parseSection)
        .where((e) => e != null)
        .toList()
        .cast<Section>();
  }
}
