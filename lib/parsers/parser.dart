import 'package:gyawun_shared/gyawun_shared.dart';
import 'package:ytmusic/models/album.dart';
import 'package:ytmusic/models/artist.dart';
import 'package:ytmusic/utils/filters.dart';
import 'package:ytmusic/utils/get_item_type.dart';
import 'package:ytmusic/utils/get_section_item.dart';
import 'package:ytmusic/utils/pretty_print.dart';
import 'package:ytmusic/utils/traverse.dart';

class Parser {
  static Section? parseSection(data) {
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

  static SectionItem? parseSectionItem(data) {
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

  static ChipItem parseChips(data) {
    final chipData = data['chipCloudChipRenderer'];
    final endpoint = traverse(chipData, ['navigationEndpoint']);
    if (endpoint['browseEndpoint'] != null) {}
    return ChipItem(
      type: endpoint['browseEndpoint'] != null
          ? ChipType.browse
          : ChipType.search,
      title: traverseString(chipData, ['text', 'runs', 'text']) ?? "",
      endpoint: endpoint['browseEndpoint'] ?? endpoint['searchEndpoint'],
    );
  }

  static Section _musicCarouselShelfRenderer(data) {
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
    return Section(
      title: traverseString(header, ['title', 'runs', 'text']) ?? '',
      itemsPerColumn: data['numItemsPerColumn'] != null
          ? int.tryParse(data['numItemsPerColumn'])
          : null,
      trailing: endpoint is Map
          ? SectionTrailing(
              text:
                  traverseString(header, [
                    'moreContentButton',
                    'buttonRenderer',
                    'text',
                    'runs',
                    'text',
                  ]) ??
                  '',
              endpoint: endpoint.cast(),
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
          ? SectionType.multiColumnRow
          : contentsData.firstOrNull?['musicMultiRowListItemRenderer'] != null
          ? SectionType.multiColumn
          : contentsData.firstOrNull?['musicResponsiveListItemRenderer'] != null
          ? SectionType.multiColumn
          : SectionType.row,
      provider: DataProvider.ytmusic,
    );
  }

  static Section _musicPlaylistShelfRenderer(data) {
    return Section(
      title: '',
      items: data['contents']
          .map((json) => parseSectionItem(json))
          .where((e) => e != null)
          .toList()
          .cast<SectionItem>(),
      type: data['collapsedItemCount'] != null
          ? SectionType.singleColumn
          : SectionType.row,
      provider: DataProvider.ytmusic,
      trailing: null,
    );
  }

  static Section _gridRenderer(data) {
    return Section(
      title: "",
      type: SectionType.grid,
      items: data['items']
          .map((json) => parseSectionItem(json))
          .where((e) => e != null)
          .toList()
          .cast<SectionItem>(),
      provider: DataProvider.ytmusic,
      trailing: null,
    );
  }

  static Section? _musicShelfRenderer(data) {
    if (data['contents'] == null) return null;
    SectionTrailing? trailing;
    final trailingText = traverseString(data, ["bottomText", "runs", "text"]);
    dynamic trailingEndpoint = data?["bottomEndpoint"]?["searchEndpoint"];
    trailingEndpoint ??= data?["bottomEndpoint"]?['browseEndpoint'];
    // pprint(data['bottomEndpoint']);
    if (trailingText != null && trailingEndpoint != null) {
      trailing = SectionTrailing(
        text: trailingText,
        endpoint: trailingEndpoint,
        isPlayable: false,
      );
    }
    return Section(
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
          .cast<SectionItem>(),
      type: SectionType.singleColumn,
      trailing: trailing,
      provider: DataProvider.ytmusic,
    );
  }

  static _musicCardShelfRenderer(data) {
    final header = traverseString(data['header'], [
      "musicCardShelfHeaderBasicRenderer",
      "title",
      "runs",
      "text",
    ]);
    final thumbnails =
        traverseList(data['thumbnail'], [
              'musicThumbnailRenderer',
              'thumbnail',
              'thumbnails',
            ])
            .map(
              (json) => Thumbnail(
                width: json['width'],
                height: json['height'],
                url: json['url'],
              ),
            )
            .toList();
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
    final album = albumData?.map((json) {
      final k = YTAlbumBasic.fromJson(json);
      return Album(id: k.id, name: k.title, endpoint: k.endpoint.cast());
    }).firstOrNull;
    final artists = artistsData?.map((json) {
      final k = YTArtistBasic.fromJson(json);
      return Artist(id: k.id, name: k.title, endpoint: k.endpoint.cast());
    }).toList();
    final contents = traverseList(data, ["contents"]);
    return Section(
      title: header ?? "",
      items: [
        getSectionItem(
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
      trailing: null,
      provider: DataProvider.ytmusic,
    );
  }

  static SectionItem? _musicResponsiveListItemRenderer(data) {
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
        .map(
          (json) => Thumbnail(
            width: json['width'],
            height: json['height'],
            url: json['url'],
          ),
        )
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
    final artists = artistsData.map((json) {
      final k = YTArtistBasic.fromJson(json);
      return Artist(id: k.id, name: k.title, endpoint: k.endpoint.cast());
    }).toList();
    final album = albumData.map((json) {
      final k = YTAlbumBasic.fromJson(json);
      return Album(id: k.id, name: k.title, endpoint: k.endpoint.cast());
    }).firstOrNull;
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

    return getSectionItem(
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

  static SectionItem? _musicTwoRowItemRenderer(data) {
    // "thumbnailRenderer","aspectRatio","title","subtitle","navigationEndpoint","trackingParams","menu","thumbnailOverlay"
    // final isRectangle =
    //     data['aspectRatio'] != null &&
    //     data['aspectRatio'].toString().endsWith("16_9");
    final thumbnails =
        traverseList(data['thumbnailRenderer'], [
              'musicThumbnailRenderer',
              'thumbnail',
              'thumbnails',
            ])
            .map(
              (json) => Thumbnail(
                width: json['width'],
                height: json['height'],
                url: json['url'],
              ),
            )
            .toList();
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
    final artists = artistsData.map((json) {
      final k = YTArtistBasic.fromJson(json);
      return Artist(id: k.id, name: k.title, endpoint: k.endpoint.cast());
    }).toList();
    dynamic id = traverseString(endpoint, ['browseId']);
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
    if (getItemType(type) == SectionItemType.video ||
        getItemType(type) == SectionItemType.song ||
        getItemType(type) == SectionItemType.episode) {
      id = endpoint['videoId'];
    }

    return getSectionItem(
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
  }

  static SectionItem? _musicMultiRowListItemRenderer(data) {
    // ["trackingParams","thumbnail","overlay","onTap","menu","subtitle","playbackProgress","title","description","displayStyle"]
    final thumbnails =
        traverseList(data['thumbnail'], [
              'musicThumbnailRenderer',
              'thumbnail',
              'thumbnails',
            ])
            .map(
              (json) => Thumbnail(
                width: json['width'],
                height: json['height'],
                url: json['url'],
              ),
            )
            .toList();
    final title = traverseString(data['title'], ['runs', 'text']);
    final navigationEndpoint = traverse(data['title'], [
      'runs',
      'navigationEndpoint',
    ]);
    final endpoint = traverse(navigationEndpoint, ['browseEndpoint']);
    dynamic id = traverse(data['onTap'], ['watchEndpoint', 'videoId']);
    id ??= traverseString(endpoint, ['browseId']);
    final type = traverseString(endpoint, [
      'browseEndpointContextSupportedConfigs',
      'browseEndpointContextMusicConfig',
      'pageType',
    ]);
    final subtitle = traverseList(data['subtitle'], ['runs', 'text']).join('');
    final description = traverseString(data['description'], ['runs', 'text']);
    return getSectionItem(
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

  static SectionItem? _playlistPanelVideoRenderer(data) {
    // "title", "longBylineText", "thumbnail", "lengthText", "selected", "navigationEndpoint", "videoId", "shortBylineText", "trackingParams", "menu", "playlistSetVideoId", "canReorder", "queueNavigationEndpoint"
    final title = traverseString(data['title'], ['runs', 'text']);
    final thumbnails = traverseList(data['thumbnail'], ['thumbnails'])
        .map(
          (json) => Thumbnail(
            width: json['width'],
            height: json['height'],
            url: json['url'],
          ),
        )
        .toList();
    final endpoint = data['navigationEndpoint']['watchEndpoint'];
    final videoid = data['videoId'] ?? endpoint['videoId'];
    final playlistId = endpoint['playlistId'];
    final menuItems = data['menu']['menuRenderer']['items'] as List;
    final shuffleItem = menuItems.firstWhere(isShuffle, orElse: () => null);
    final radioItem = menuItems.firstWhere(isRadio, orElse: () => null);
    final runs = data['longBylineText']?['runs'] as List?;
    final artistsdata = runs?.where(isArtist).toList();
    final albumData = runs?.firstWhere(isAlbum, orElse: () => null);

    final artists = artistsdata?.map((json) {
      final k = YTArtistBasic.fromJson(json);
      return Artist(id: k.id, name: k.title, endpoint: k.endpoint.cast());
    }).toList();
    Album? album;
    if (albumData != null) {
      album = Album(
        name: albumData['text'],
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

    return getSectionItem(
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

  static SectionItem? _musicNavigationButtonRenderer(data) {
    final title = traverseString(data['buttonText'], ['runs', 'text']);
    final endpoint = traverse(data['clickCommand'], ['browseEndpoint']);
    final id = traverseString(endpoint, ['browseId']);
    if (title == null || endpoint == null) return null;
    return SectionItem(
      title: title,
      endpoint: endpoint,
      id: id ?? "",
      subtitle: null,
      thumbnails: [],
      radioEndpoint: null,
      shuffleEndpoint: {},
      provider: DataProvider.ytmusic,
      type: SectionItemType.button,
    );
  }

  static PageHeader parsePageHeader(data) {
    final title = traverseString(data, ['title', 'runs', 'text']);
    final subtitle = traverseList(data, ['subtitle', 'runs', 'text']).join('');
    // final secondSubtitle = traverseList(data, [
    //   'secondSubtitle',
    //   'runs',
    //   'text',
    // ]).join('');

    String? description = traverseString(data, ['description', 'runs', 'text']);
    description ??= traverseString(data, [
      'description',
      'description',
      'runs',
      'text',
    ]);

    final thumbnails =
        traverseList(data, ['thumbnail', 'thumbnail', 'thumbnails'])
            .map(
              (json) => Thumbnail(
                width: json['width'],
                height: json['height'],
                url: json['url'],
              ),
            )
            .toList();

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
    return PageHeader(
      title: title ?? '',
      subtitle: subtitle,
      description: description ?? '',
      thumbnails: thumbnails,
      playEndpoint: (playEndpoint is Map) ? Map.from(playEndpoint) : null,
      radioEndpoint: radioEndpoint,
      shuffleEndpoint: shuffleEndpoint,
      id: '',
      modules: [],
    );
  }
}
