import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/client.dart';
import 'package:ytmusic/parsers/playlist.dart';

mixin SongsMixin on YTClient {
  Future<List<SectionItem>> getNextSongs({
    required Map<String, dynamic> body,
  }) async {
    final data = await sendRequest("next", body: body);
    return PlaylistParser.parseSongs(data);
  }
}
