import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/client.dart';
import 'package:ytmusic/models/search.dart';
import 'package:ytmusic/parsers/search.dart';

mixin SearchMixin on YTClient {
  Future<YTSearchSuggestions> getSearchSuggestions({
    required String query,
  }) async {
    final data = await sendRequest(
      "music/get_search_suggestions",
      body: {"input": query},
    );
    return SearchParser.parseSuggestions(data);
  }

  Future<Page> getSearch({required String query}) async {
    final data = await sendRequest("search", body: {"query": query});
    return SearchParser.parse(data);
  }
}
