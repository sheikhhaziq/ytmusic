import 'traverse.dart';

bool isTitle(dynamic data) {
  return traverseString(data, [
        "musicVideoType",
      ])?.startsWith("MUSIC_VIDEO_TYPE_") ??
      false;
}

bool isArtist(dynamic data) {
  final pageType = traverseString(data, ["pageType"]);
  return [
    "MUSIC_PAGE_TYPE_USER_CHANNEL",
    "MUSIC_PAGE_TYPE_ARTIST",
  ].contains(pageType);
}

bool isAlbum(dynamic data) {
  return traverseString(data, ["pageType"]) == "MUSIC_PAGE_TYPE_ALBUM";
}

bool isShuffle(dynamic data) {
  return traverseString(data, ['icon', 'iconType']) == 'MUSIC_SHUFFLE';
}

bool isRadio(dynamic data) {
  return traverseString(data, ['icon', 'iconType']) == 'MIX';
}

bool isexplicit(dynamic data) {
  return traverseString(data, ['icon', 'iconType']) == 'MUSIC_EXPLICIT_BADGE';
}

bool isDuration(dynamic data) {
  final text = traverseString(data, ["text"]);
  return RegExp(r"(\d{1,2}:)?\d{1,2}:\d{1,2}").hasMatch(text ?? '');
}
