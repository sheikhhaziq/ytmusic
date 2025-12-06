import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/client.dart';
import 'package:ytmusic/parsers/browse.dart';

mixin BrowseMixin on YTClient {
  Future<Page> browseMore({required Map<String, dynamic> body}) async {
    final data = await sendRequest("browse", body: body);
    return BrowseParser.parse(data);
  }
}
