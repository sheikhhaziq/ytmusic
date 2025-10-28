import 'package:ytmusic/models/section.dart';
import 'package:ytmusic/parsers/parser.dart';
import 'package:ytmusic/utils/traverse.dart';

class ExploreParser {
  static List<YTSection> parse(data){
    final sections = traverseList(data['contents'],['tabs','tabRenderer','content','sectionListRenderer','contents']);
    return sections.map(Parser.parseSection).where((e)=>e!=null).toList().cast<YTSection>();
  }
}