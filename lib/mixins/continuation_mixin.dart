import 'package:ytmusic/client.dart';
import 'package:ytmusic/models/item_continuation.dart';
import 'package:ytmusic/parsers/item_continuation.dart';

mixin ContinuationMixin on YTClient {
  Future<SectionItemContinuation> getContinuationItems({
    required Map<String, dynamic> body,
    required String continuation,
  }) async {
    final data = await sendRequest(
      "browse",
      body: body,
      additionalParams: "&continuation=$continuation",
    );
    return ItemContinuationParser.parse(data);
  }
}
