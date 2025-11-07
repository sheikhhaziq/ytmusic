import 'package:ytmusic/enums/section_item_type.dart';
import 'package:ytmusic/enums/section_type.dart';
import 'package:ytmusic/models/album.dart';
import 'package:ytmusic/models/artist.dart';
import 'package:ytmusic/models/browse_page.dart';
import 'package:ytmusic/models/section.dart';
import 'package:ytmusic/models/thumbnail.dart';
import 'package:ytmusic/models/yt_item.dart';
import 'package:ytmusic/utils/filters.dart';
import 'package:ytmusic/utils/pretty_print.dart';
import 'package:ytmusic/utils/traverse.dart';

class Parser {
  static YTSection? parseSection(data) {
    if (data['musicCarouselShelfRenderer'] != null) {
      return _musicCarouselShelfRenderer(data['musicCarouselShelfRenderer']);
    }
    if (data['musicPlaylistShelfRenderer'] != null) {
      return _musicPlaylistShelfRenderer(data['musicPlaylistShelfRenderer']);
    }
    if (data['gridRenderer'] != null) {
      return _gridRenderer(data['gridRenderer']);
    }
    if (data['musicShelfRenderer'] != null) {
      return _musicShelfRenderer(data['musicShelfRenderer']);
    }
    if (data["musicCardShelfRenderer"] != null) {
      return _musicCardShelfRenderer(data["musicCardShelfRenderer"]);
    }

    return null;
  }

  static YTItem? parseSectionItem(data) {
    if (data['musicResponsiveListItemRenderer'] != null) {
      return _musicResponsiveListItemRenderer(
        data['musicResponsiveListItemRenderer'],
      );
    }
    if (data['musicTwoRowItemRenderer'] != null) {
      return _musicTwoRowItemRenderer(data['musicTwoRowItemRenderer']);
    }
    if (data['musicMultiRowListItemRenderer'] != null) {
      return _musicMultiRowListItemRenderer(
        data['musicMultiRowListItemRenderer'],
      );
    }
    if (data['playlistPanelVideoRenderer'] != null) {
      return _playlistPanelVideoRenderer(data['playlistPanelVideoRenderer']);
    }
    if (data['musicNavigationButtonRenderer'] != null) {
      return _musicNavigationButtonRenderer(
        data['musicNavigationButtonRenderer'],
      );
    }

    return null;
  }

  static YTSection _musicCarouselShelfRenderer(data) {
    // ["header","contents","trackingParams","itemSize","numItemsPerColumn","header","contents","trackingParams","itemSize"]
    final header = data['header']['musicCarouselShelfBasicHeaderRenderer'];
    final headerNavigationEndpoint = traverse(header, [
      'moreContentButton',
      'navigationEndpoint',
    ]);

    var endpoint = traverse(headerNavigationEndpoint, ['watchEndpoint']);
    if (endpoint is List) {
      endpoint = traverse(headerNavigationEndpoint, ['browseEndpoint']);
    }

    final contentsData = traverseList(data, ['contents']);
    return YTSection(
      title: traverseString(header, ['title', 'runs', 'text']) ?? '',
      strapline: traverseString(header, ['strapline', 'runs', 'text']),
      itemsPerColumn: data['numItemsPerColumn'] != null
          ? int.tryParse(data['numItemsPerColumn'])
          : null,
      trailing: endpoint is Map
          ? YTSectionTrailing(
              text:
                  traverseString(header, [
                    'moreContentButton',
                    'buttonRenderer',
                    'text',
                    'runs',
                    'text',
                  ]) ??
                  '',
              endpoint: endpoint,
              isPlayable:
                  traverse(headerNavigationEndpoint, ['watchEndpoint']) is Map,
            )
          : null,
      items: contentsData
          .map(parseSectionItem)
          .where((item) => item != null)
          .toList()
          .cast(),
      type: contentsData.firstOrNull?["musicNavigationButtonRenderer"] != null
          ? YTSectionType.multiColumnRow
          : contentsData.firstOrNull?['musicMultiRowListItemRenderer'] != null
          ? YTSectionType.multiColumn
          : contentsData.firstOrNull?['musicResponsiveListItemRenderer'] != null
          ? YTSectionType.multiColumn
          : YTSectionType.row,
      // type: data['numItemsPerColumn'] != null
      //     ? YTSectionType.multiColumn
      //     : ([
      //             "COLLECTION_STYLE_ITEM_SIZE_SMALL",
      //             "COLLECTION_STYLE_ITEM_SIZE_MEDIUM",
      //           ].contains(data['itemSize'])
      //           ? YTSectionType.row
      //           : YTSectionType.singleColumn),
    );
  }

  static YTSection _musicPlaylistShelfRenderer(data) {
    return YTSection(
      title: '',
      items: data['contents']
          .map((json) => parseSectionItem(json))
          .where((e) => e != null)
          .toList()
          .cast<YTItem>(),
      type: data['collapsedItemCount'] != null
          ? YTSectionType.singleColumn
          : YTSectionType.row,
    );
  }

  static YTSection _gridRenderer(data) {
    return YTSection(
      title: "",
      type: YTSectionType.grid,
      items: data['items']
          .map((json) => parseSectionItem(json))
          .where((e) => e != null)
          .toList()
          .cast<YTItem>(),
    );
  }

  static YTSection? _musicShelfRenderer(data) {
    if (data['contents'] == null) return null;
    YTSectionTrailing? trailing;
    final trailingText = traverseString(data, ["bottomText", "runs", "text"]);
    dynamic trailingEndpoint = data?["bottomEndpoint"]?["searchEndpoint"];
    trailingEndpoint ??= data?["bottomEndpoint"]?['browseEndpoint'];
    // pprint(data['bottomEndpoint']);
    if (trailingText != null && trailingEndpoint != null) {
      trailing = YTSectionTrailing(
        text: trailingText,
        endpoint: trailingEndpoint,
        isPlayable: false,
      );
    }
    return YTSection(
      title: traverseString(data, ["title", "runs", "text"]) ?? "",
      continuation: traverseString(data, [
        'continuations',
        'nextContinuationData',
        'continuation',
      ]),
      items: data['contents']
          .map((json) => parseSectionItem(json))
          .where((e) => e != null)
          .toList()
          .cast<YTItem>(),
      type: YTSectionType.singleColumn,
      trailing: trailing,
    );
  }

  static _musicCardShelfRenderer(data) {
    final header = traverseString(data['header'], [
      "musicCardShelfHeaderBasicRenderer",
      "title",
      "runs",
      "text",
    ]);
    final thumbnails = traverseList(data['thumbnail'], [
      'musicThumbnailRenderer',
      'thumbnail',
      'thumbnails',
    ]).map((json) => YTThumbnail.fromJson(json)).toList();
    final title = traverse(data['title'], ['runs', 'text']);
    final navigationEndpoint = traverse(data['title'], [
      'runs',
      'navigationEndpoint',
    ]);
    final endpoint =
        navigationEndpoint?['browseEndpoint'] ??
        navigationEndpoint?['watchEndpoint'];
    final id = endpoint?['browseId'] ?? endpoint?['videoId'];
    dynamic type =
        endpoint?['watchEndpointMusicSupportedConfigs']?['watchEndpointMusicConfig']?['musicVideoType'];
    type ??=
        endpoint?["browseEndpointContextSupportedConfigs"]?["browseEndpointContextMusicConfig"]?['pageType'];
    final subtitle = traverseList(data['subtitle'], ["runs", "text"]).join("");
    final albumData = (data['subtitle']?['runs'] as List?)
        ?.where(isAlbum)
        .toList();
    final artistsData = (data['subtitle']?['runs'] as List?)
        ?.where(isArtist)
        .toList();
    final album = albumData
        ?.map((json) => YTAlbumBasic.fromJson(json))
        .firstOrNull;
    final artists = artistsData
        ?.map((json) => YTArtistBasic.fromJson(json))
        .toList();
    final contents = traverseList(data, ["contents"]);
    return YTSection(
      title: header ?? "",
      items: [
        YTItem.itemFrom(
          getItemType(type),
          title: title,
          subtitle: subtitle,
          playlistId: "",
          artists: artists ?? [],
          album: album,
          id: id,
          thumbnails: thumbnails,
          endpoint: endpoint,
          description: "",
        )!,
        ...contents
            .map((json) => parseSectionItem(json))
            .where((e) => e != null)
            .toList()
            .cast(),
      ],
    );
  }

  static YTItem? _musicResponsiveListItemRenderer(data) {
    // ["trackingParams","thumbnail","overlay","flexColumns","menu","playlistItemData","flexColumnDisplayStyle","itemHeight"]
    final thumbnailsData = traverseList(data, [
      'thumbnail',
      'musicThumbnailRenderer',
      'thumbnail',
      'thumbnails',
    ]);
    final flexColumns = traverseList(data, [
      'flexColumns',
      'musicResponsiveListItemFlexColumnRenderer',
    ]);
    final flexColumnsExpanded = traverseList(data, [
      'flexColumns',
      'musicResponsiveListItemFlexColumnRenderer',
      'text',
      'runs',
    ]);
    final thumbnails = thumbnailsData
        .map((json) => YTThumbnail.fromJson(json))
        .toList();
    final title =
        traverseString(flexColumns[0], ['text', 'runs', 'text']) ?? '';
    final navigationEndpoint =
        data['navigationEndpoint'] ??
        traverse(flexColumns[0], ['text', 'runs', 'navigationEndpoint']);
    dynamic endpoint = traverse(navigationEndpoint, ['watchEndpoint']);

    if (endpoint is List) {
      endpoint = traverse(navigationEndpoint, ['browseEndpoint']);
    }
    if (endpoint is List) return null;

    final id =
        traverseString(navigationEndpoint, ['videoId']) ??
        traverseString(navigationEndpoint, ['browseId']) ??
        traverseString(data, ['playlistItemData', 'videoId']) ??
        '';
    final playlistId = traverseString(endpoint, ['playlistId']) ?? 'RDAMVM$id';

    final subtitle = traverseList(flexColumns[1], [
      'text',
      'runs',
      'text',
    ]).join('');
    final albumData = flexColumnsExpanded.where(isAlbum);
    final artistsData = flexColumnsExpanded.where(isArtist).toList();
    final artists = artistsData
        .map((json) => YTArtistBasic.fromJson(json))
        .toList();
    final album = albumData
        .map((json) => YTAlbumBasic.fromJson(json))
        .firstOrNull;
    final menuItems = traverseList(data['menu'], [
      'items',
      'menuNavigationItemRenderer',
    ]);
    final radio = menuItems.firstWhere(isRadio, orElse: () => null);
    dynamic radioEndpoint;

    if (radio != null) {
      radioEndpoint = traverse(radio, ['navigationEndpoint', 'watchEndpoint']);
    }
    if (radioEndpoint is List) {
      radioEndpoint = traverse(radio, [
        'navigationEndpoint',
        'watchPlaylistEndpoint',
      ]);
    }
    final type =
        traverseString(endpoint, [
          'watchEndpointMusicSupportedConfigs',
          'watchEndpointMusicConfig',
          'musicVideoType',
        ]) ??
        traverseString(endpoint, [
          "browseEndpointContextSupportedConfigs",
          "browseEndpointContextMusicConfig",
          "pageType",
        ]);

    return YTItem.itemFrom(
      getItemType(type),
      id: id,
      title: title,
      subtitle: subtitle,
      description: "",
      playlistId: playlistId,
      thumbnails: thumbnails,
      album: album,
      artists: artists,
      endpoint: endpoint,
      radioEndpoint: radioEndpoint,
      shuffleEndpoint: null,
    );
  }

  static YTItem? _musicTwoRowItemRenderer(data) {
    // "thumbnailRenderer","aspectRatio","title","subtitle","navigationEndpoint","trackingParams","menu","thumbnailOverlay"
    // final isRectangle =
    //     data['aspectRatio'] != null &&
    //     data['aspectRatio'].toString().endsWith("16_9");
    final thumbnails = traverseList(data['thumbnailRenderer'], [
      'musicThumbnailRenderer',
      'thumbnail',
      'thumbnails',
    ]).map((json) => YTThumbnail.fromJson(json)).toList();
    final title = traverseString(data['title'], ['runs', 'text']);

    dynamic endpoint = traverse(data['title'], [
      'runs',
      'navigationEndpoint',
      'browseEndpoint',
    ]);
    if (endpoint is List) {
      endpoint = traverse(data['navigationEndpoint'], ['browseEndpoint']);
    }
    if (endpoint is List) {
      endpoint = traverse(data['title'], [
        'runs',
        'navigationEndpoint',
        'watchEndpoint',
      ]);
    }
    if (endpoint is List) {
      endpoint = traverse(data['navigationEndpoint'], ['watchEndpoint']);
    }
    if (endpoint is List) {
      pprint(data);
    }
    final artistsData = traverseList(data['subtitle'], [
      'runs',
    ]).where(isArtist).toList();
    final artists = artistsData
        .map((json) => YTArtistBasic.fromJson(json))
        .toList();
    final id = traverseString(endpoint, ['browseId']);
    final type =
        traverseString(endpoint, [
          'browseEndpointContextSupportedConfigs',
          'browseEndpointContextMusicConfig',
          'pageType',
        ]) ??
        traverseString(endpoint, [
          'watchEndpointMusicSupportedConfigs',
          'watchEndpointMusicConfig',
          'musicVideoType',
        ]);
    final subtitle = traverseList(data['subtitle'], ['runs', 'text']).join();
    final menuItems = traverseList(data['menu'], [
      'items',
      'menuNavigationItemRenderer',
    ]);
    final shuffle = menuItems.firstWhere(isShuffle, orElse: () => null);
    final radio = menuItems.firstWhere(isRadio, orElse: () => null);
    Map? shuffleEndpoint;
    Map? radioEndpoint;
    if (shuffle != null) {
      final s = traverse(shuffle, [
        'navigationEndpoint',
        'watchPlaylistEndpoint',
      ]);
      if (s is! Map) {
        shuffleEndpoint = traverse(shuffle, [
          'navigationEndpoint',
          'watchPlaylistEndpoint',
        ]);
      } else {
        shuffleEndpoint = s;
      }
    }
    if (radio != null) {
      final r = traverse(radio, [
        'navigationEndpoint',
        'watchPlaylistEndpoint',
      ]);
      if (r is! Map) {
        radioEndpoint = traverse(radio, [
          'navigationEndpoint',
          'watchEndpoint',
        ]);
      } else {
        radioEndpoint = r;
      }
    }

    return YTItem.itemFrom(
      getItemType(type),
      id: id ?? "",
      title: title ?? "",
      subtitle: subtitle,
      description: "",
      playlistId: "",
      thumbnails: thumbnails,
      album: null,
      artists: artists,
      endpoint: endpoint,
      shuffleEndpoint: shuffleEndpoint?.cast<String, dynamic>(),
      radioEndpoint: radioEndpoint?.cast<String, dynamic>(),
    );
    // return YTSectionItem(
    //   title: title ?? '',
    //   id: id ?? '',
    //   thumbnails: thumbnails,
    //   type: getSectionItemType(type),
    //   subtitle: subtitle,
    //   endpoint: endpoint is Map ? endpoint : null,
    //   shuffleEndpoint: shuffleEndpoint,
    //   radioEndpoint: radioEndpoint,
    //   isRectangle: isRectangle,
    // );
  }

  static YTItem? _musicMultiRowListItemRenderer(data) {
    // ["trackingParams","thumbnail","overlay","onTap","menu","subtitle","playbackProgress","title","description","displayStyle"]
    final thumbnails = traverseList(data['thumbnail'], [
      'musicThumbnailRenderer',
      'thumbnail',
      'thumbnails',
    ]).map((json) => YTThumbnail.fromJson(json)).toList();
    final title = traverseString(data['title'], ['runs', 'text']);
    final navigationEndpoint = traverse(data['title'], [
      'runs',
      'navigationEndpoint',
    ]);
    final endpoint = traverse(navigationEndpoint, ['browseEndpoint']);

    final id = traverseString(endpoint, ['browseId']);
    final type = traverseString(endpoint, [
      'browseEndpointContextSupportedConfigs',
      'browseEndpointContextMusicConfig',
      'pageType',
    ]);
    final subtitle = traverseList(data['subtitle'], ['runs', 'text']).join('');
    final description = traverseString(data['description'], ['runs', 'text']);

    return YTItem.itemFrom(
      getItemType(type),
      id: id ?? "",
      title: title ?? "",
      subtitle: subtitle,
      description: description ?? "",
      playlistId: "",
      thumbnails: thumbnails,
      album: null,
      artists: [],
      endpoint: endpoint,
      shuffleEndpoint: null,
      radioEndpoint: null,
    );
    // return YTSectionItem(
    //   title: title ?? '',
    //   id: id ?? "",
    //   thumbnails: thumbnails,
    //   type: getSectionItemType(type),
    //   subtitle: subtitle,
    //   desctiption: description,
    // );
  }

  static YTItem? _playlistPanelVideoRenderer(data) {
    // "title", "longBylineText", "thumbnail", "lengthText", "selected", "navigationEndpoint", "videoId", "shortBylineText", "trackingParams", "menu", "playlistSetVideoId", "canReorder", "queueNavigationEndpoint"
    final title = traverseString(data['title'], ['runs', 'text']);
    final thumbnails = traverseList(data['thumbnail'], [
      'thumbnails',
    ]).map((json) => YTThumbnail.fromJson(json)).toList();
    final endpoint = data['navigationEndpoint']['watchEndpoint'];
    final videoid = data['videoId'] ?? endpoint['videoId'];
    final playlistId = endpoint['playlistId'];
    final menuItems = data['menu']['menuRenderer']['items'] as List;
    final shuffleItem = menuItems.firstWhere(isShuffle, orElse: () => null);
    final radioItem = menuItems.firstWhere(isRadio, orElse: () => null);
    final runs = data['longBylineText']?['runs'] as List?;
    final artistsdata = runs?.where(isArtist).toList();
    final albumData = runs?.firstWhere(isAlbum, orElse: () => null);

    final artists = artistsdata
        ?.map(
          (json) => YTArtistBasic(
            title: json['text'],
            endpoint: json['navigationEndpoint']['browseEndpoint'],
            id: json['navigationEndpoint']['browseEndpoint']['browseId'],
          ),
        )
        .toList();
    YTAlbumBasic? album;
    if (albumData != null) {
      album = YTAlbumBasic(
        title: albumData['text'],
        endpoint: albumData['navigationEndpoint']['browseEndpoint'],
        id: albumData['navigationEndpoint']['browseEndpoint']['browseId'],
      );
    }
    final subtitle = traverseList(runs, ['text']).join('');
    dynamic radio;
    if (radioItem != null) {
      radio = traverse(radioItem, ['navigationEndpoint', 'watchEndpoint']);
    }
    dynamic shuffle;
    if (shuffleItem != null) {
      shuffle = traverse(shuffleItem, [
        'navigationEndpoint',
        'watchPlaylistEndpoint',
      ]);
    }
    final type = traverseString(endpoint, [
      'watchEndpointMusicSupportedConfigs',
      'watchEndpointMusicConfig',
      'musicVideoType',
    ]);
    return YTItem.itemFrom(
      getItemType(type),
      id: videoid,
      title: title ?? '',
      subtitle: subtitle,
      description: "",
      playlistId: playlistId ?? '',
      thumbnails: thumbnails,
      album: album,
      artists: artists ?? [],
      endpoint: endpoint,
      shuffleEndpoint: shuffle,
      radioEndpoint: radio,
    );
    // return YTSectionItem(
    //   title: title ?? '',
    //   subtitle: subtitle,
    //   id: videoid ?? "",
    //   thumbnails: thumbnails,
    //   artists: artists ?? [],
    //   album: album,
    //   endpoint: endpoint,
    //   radioEndpoint: radio,
    //   shuffleEndpoint: shuffle,
    //   playlistId: playlistId,
    //   type: getSectionItemType(type),
    // );
  }

  static YTButtonItem? _musicNavigationButtonRenderer(data) {
    final title = traverseString(data['buttonText'], ['runs', 'text']);
    final endpoint = traverse(data['clickCommand'], ['browseEndpoint']);
    final id = traverseString(endpoint, ['browseId']);
    if (title == null || endpoint == null) return null;
    return YTButtonItem(title: title, endpoint: endpoint, id: id ?? "");
  }

  static YTPageHeader parsePageHeader(data) {
    final title = traverseString(data, ['title', 'runs', 'text']);
    final subtitle = traverseList(data, ['subtitle', 'runs', 'text']).join('');
    final secondSubtitle = traverseList(data, [
      'secondSubtitle',
      'runs',
      'text',
    ]).join('');

    String? description = traverseString(data, ['description', 'runs', 'text']);
    description ??= traverseString(data, [
      'description',
      'description',
      'runs',
      'text',
    ]);

    final thumbnails = traverseList(data, [
      'thumbnail',
      'thumbnail',
      'thumbnails',
    ]).map((json) => YTThumbnail.fromJson(json)).toList();

    final buttons = data['buttons'];

    var playEndpoint = traverse(buttons, [
      'musicPlayButtonRenderer',
      'playNavigationEndpoint',
      'watchEndpoint',
    ]);
    if (playEndpoint is! Map) {
      playEndpoint = traverse(buttons, [
        'musicPlayButtonRenderer',
        'playNavigationEndpoint',
        'watchPlaylistEndpoint',
      ]);
    }
    final menuRenderer = traverseList(buttons, [
      'menuRenderer',
      'items',
      'menuNavigationItemRenderer',
    ]);
    if (data['playButton']?['buttonRenderer'] != null) {
      menuRenderer.add(data['playButton']?['buttonRenderer']);
    }
    if (data['startRadioButton']?['buttonRenderer'] != null) {
      menuRenderer.add(data['startRadioButton']?['buttonRenderer']);
    }

    final shuffleNavigation = menuRenderer.firstWhere(
      isShuffle,
      orElse: () => null,
    )?["navigationEndpoint"];
    dynamic shuffleEndpoint = shuffleNavigation?['watchPlaylistEndpoint'];
    shuffleEndpoint ??= shuffleNavigation?["watchEndpoint"];

    final radioNavigation = menuRenderer.firstWhere(
      isRadio,
      orElse: () => null,
    )?['navigationEndpoint'];
    dynamic radioEndpoint = radioNavigation?['watchPlaylistEndpoint'];
    radioEndpoint ??= radioNavigation?["watchEndpoint"];
    return YTPageHeader(
      title: title ?? '',
      subtitle: subtitle,
      secondSubtitle: secondSubtitle,
      description: description ?? '',
      thumbnails: thumbnails,
      playEndpoint: (playEndpoint is Map) ? Map.from(playEndpoint) : null,
      radioEndpoint: radioEndpoint,
      shuffleEndpoint: shuffleEndpoint,
    );
  }
}
