import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/client.dart';
import 'package:ytmusic/models/continuation_page.dart';
import 'package:ytmusic/parsers/playlist.dart';
import 'package:ytmusic/utils/isolate.dart';

mixin PlaylistMixin on YTClient {
  Future<Page> getPlaylist({required Map<String, dynamic> body}) async {
    final data = await sendRequest("browse", body: body);
    return runInIsolate(PlaylistParser.parse, data);
  }

  Future<ContinuationPage> getPlaylistSectionContinuation({
    required Map<String, dynamic> body,
    required String continuation,
  }) async {
    final data = await sendRequest(
      "browse",
      body: body,
      additionalParams: "&continuation=$continuation",
    );
    return runInIsolate(PlaylistParser.parseContinuation, data);
  }
}
