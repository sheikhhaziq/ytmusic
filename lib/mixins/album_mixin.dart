import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/client.dart';
import 'package:ytmusic/parsers/album.dart';

mixin AlbumMixin on YTClient {
  Future<Page> getAlbum({required Map<String, dynamic> body}) async {
    final data = await sendRequest("browse", body: body);
    if (data['contents'] == null) {
      throw Exception("Not Found");
    }
    return AlbumParser.parse(data);
  }
}
