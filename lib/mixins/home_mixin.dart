import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/client.dart';
import 'package:ytmusic/models/continuation_page.dart';
import 'package:ytmusic/parsers/home_page.dart';

mixin HomeMixin on YTClient {
  Future<Page> getHomePage({int limit = 1}) async {
    final data = await sendRequest(
      "browse",
      body: {"browseId": 'FEmusic_home'},
    );

    // final home = await runInIsolate(HomePageParser.parse, data);
    final home = HomePageParser.parse(data);
    while (home.sections.length < limit && home.continuation != null) {
      final conti = await getHomePageContinuation(
        continuation: home.continuation!,
      );
      home.sections = [...home.sections, ...conti.sections];
      home.continuation = conti.continuation;
    }
    return home;
  }

  Future<ContinuationPage> getHomePageContinuation({
    required String continuation,
  }) async {
    final data = await sendRequest(
      "browse",
      body: {"browseId": "FEmusic_home"},
      additionalParams: "&continuation=$continuation",
    );

    // return runInIsolate(HomePageParser.parseContinuation, data);
    return HomePageParser.parseContinuation(data);
  }
}
