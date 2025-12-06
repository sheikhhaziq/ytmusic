import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/client.dart';
import 'package:ytmusic/parsers/artist.dart';

mixin ArtistMixin on YTClient {
  Future<Page> getArtist({required Map<String, dynamic> body}) async {
    final data = await sendRequest("browse", body: body);
    return ArtistParser.parse(data);
  }
}
