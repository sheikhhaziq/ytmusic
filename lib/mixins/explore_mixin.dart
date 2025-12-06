import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/client.dart';
import 'package:ytmusic/parsers/explore.dart';

mixin ExploreMixin on YTClient {
  Future<List<Section>> getExplore() async {
    final data = await sendRequest(
      "browse",
      body: {"browseId": "FEmusic_explore"},
    );
    return ExploreParser.parse(data);
  }
}
