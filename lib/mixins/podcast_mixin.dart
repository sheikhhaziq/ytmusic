import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/client.dart';
import 'package:ytmusic/models/continuation_page.dart';
import 'package:ytmusic/parsers/podcast.dart';

mixin PodcastMixin on YTClient {
  Future<Page> getPodcast({required Map<String, dynamic> body}) async {
    final data = await sendRequest("browse", body: body);
    return PodcastParser.parse(data);
  }

  Future<ContinuationPage> getPodcastContinuation({
    required Map<String, dynamic> body,
    required String continuation,
  }) async {
    final data = await sendRequest(
      "browse",
      body: body,
      additionalParams: "&continuation=$continuation",
    );
    return PodcastParser.parseContinuation(data);
  }
}
