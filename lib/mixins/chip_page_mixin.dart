import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/client.dart';
import 'package:ytmusic/models/continuation_page.dart';
import 'package:ytmusic/parsers/chip.dart';
import 'package:ytmusic/utils/isolate.dart';

mixin ChipPageMixin on YTClient {
  Future<Page> getChipPage({
    required Map<String, dynamic> body,
    int limit = 1,
    ChipType type = ChipType.browse,
  }) async {
    final data = await sendRequest(
      type == ChipType.browse ? "browse" : "search",
      body: body,
    );
    final chip = await runInIsolate(ChipPageParser.parse, data);
    while (chip.sections.length < limit && chip.continuation != null) {
      final conti = await getChipPageContinuation(
        body: body,
        continuation: chip.continuation!,
        type: type,
      );
      chip.sections = [...chip.sections, ...conti.sections];
      chip.continuation = conti.continuation;
    }
    return chip;
  }

  Future<ContinuationPage> getChipPageContinuation({
    required Map<String, dynamic> body,
    required String continuation,
    ChipType type = ChipType.browse,
  }) async {
    final data = await sendRequest(
      type == ChipType.browse ? "browse" : "search",
      body: body,
      additionalParams: "&continuation=$continuation",
    );
    return runInIsolate(ChipPageParser.parseContinuation, data);
  }
}
