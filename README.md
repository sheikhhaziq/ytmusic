# YTMusic

A comprehensive Dart package for accessing YouTube Music data and functionality. Built for the Gyawun app, this package provides a clean and efficient API for interacting with YouTube Music's content including songs, albums, artists, playlists, podcasts, and more.

## Features

- 🎵 **Search** - Search for songs, albums, artists, and playlists with autocomplete suggestions
- 🏠 **Home Feed** - Fetch personalized home page content with continuation support
- 🎨 **Browse** - Explore albums, artists, playlists, and podcasts
- 📻 **Explore** - Discover new music through YouTube Music's explore section
- 🎧 **Playlists** - Get detailed playlist information and song lists
- 🎤 **Artists** - Browse artist pages and their content
- 💿 **Albums** - Access complete album details and tracks
- 🎙️ **Podcasts** - Support for podcast content
- 🔄 **Pagination** - Built-in continuation support for loading more content
- 💾 **Caching** - Optional database caching for improved performance
- 🌍 **Localization** - Configurable language and location settings

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  ytmusic:
    git:
      url: https://github.com/sheikhhaziq/ytmusic.git
```

Then run:

```bash
dart pub get
```

## Usage

### Basic Setup

```dart
import 'package:ytmusic/ytmusic.dart';

// Initialize with default configuration
final ytMusic = YTMusic();

// Or with custom configuration
final ytMusic = YTMusic(
  config: YTConfig(
    visitorData: "your_visitor_data",
    language: "en",
    location: "US",
  ),
  cookies: "your_cookies_string",
  cacheDatabasePath: "path/to/cache.db",
  onConfigUpdate: (newConfig) {
    // Handle config updates
    print("Config updated: ${newConfig.visitorData}");
  },
);
```

### Fetching Configuration

```dart
// Fetch YouTube Music configuration
final config = await YTMusic.fetchConfig();
if (config != null) {
  ytMusic.setConfig(config);
}
```

### Home Page

```dart
// Get home page with default sections
final homePage = await ytMusic.getHomePage();

// Get more sections (pagination)
final homePage = await ytMusic.getHomePage(limit: 5);

// Handle sections
for (final section in homePage.sections) {
  print('Section: ${section.title}');
  for (final item in section.items) {
    // Process items
  }
}

// Load more content using continuation
if (homePage.continuation != null) {
  final morePage = await ytMusic.getHomePageContinuation(
    continuation: homePage.continuation!,
  );
}
```

### Search

```dart
// Get search suggestions
final suggestions = await ytMusic.getSearchSuggestions(
  query: "billie eilish",
);

for (final suggestion in suggestions.suggestions) {
  print(suggestion);
}

// Perform search
final searchResults = await ytMusic.getSearch(
  query: "what was i made for",
);

for (final section in searchResults.sections) {
  print('Results: ${section.title}');
}
```

### Albums

```dart
final album = await ytMusic.getAlbum(
  body: {"browseId": "album_browse_id"},
);

print('Album: ${album.header?.title}');
for (final section in album.sections) {
  // Process album tracks
}
```

### Artists

```dart
final artist = await ytMusic.getArtist(
  body: {"browseId": "artist_browse_id"},
);

print('Artist: ${artist.header?.title}');
for (final section in artist.sections) {
  // Process artist content (songs, albums, etc.)
}
```

### Playlists

```dart
// Get playlist details
final playlist = await ytMusic.getPlaylist(
  body: {"browseId": "playlist_browse_id"},
);

// Get next songs for radio/autoplay
final nextSongs = await ytMusic.getNextSongs(
  body: {"videoId": "video_id"},
);

// Load more playlist content
if (playlist.continuation != null) {
  final moreSongs = await ytMusic.getPlaylistSectionContinuation(
    body: {"browseId": "playlist_browse_id"},
    continuation: playlist.continuation!,
  );
}
```

### Podcasts

```dart
final podcast = await ytMusic.getPodcast(
  body: {"browseId": "podcast_browse_id"},
);

// Load more podcast episodes
if (podcast.continuation != null) {
  final moreEpisodes = await ytMusic.getPodcastContinuation(
    body: {"browseId": "podcast_browse_id"},
    continuation: podcast.continuation!,
  );
}
```

### Explore Page

```dart
final exploreSections = await ytMusic.getExplore();

for (final section in exploreSections) {
  print('Explore section: ${section.title}');
}
```

### Chip Pages (Filter Pages)

```dart
// Browse filtered content (e.g., genre pages)
final chipPage = await ytMusic.getChipPage(
  body: {"browseId": "chip_browse_id"},
  limit: 3,
);

// Load more chip content
if (chipPage.continuation != null) {
  final more = await ytMusic.getChipPageContinuation(
    body: {"browseId": "chip_browse_id"},
    continuation: chipPage.continuation!,
  );
}
```

### Generic Browse & Continuation

```dart
// Browse any endpoint
final page = await ytMusic.browseMore(
  body: {"browseId": "any_browse_id"},
);

// Generic continuation handler
final continuationItems = await ytMusic.getContinuationItems(
  body: {"browseId": "browse_id"},
  continuation: "continuation_token",
);
```

## Configuration

### YTConfig

The `YTConfig` object allows you to customize the YouTube Music client:

```dart
final config = YTConfig(
  visitorData: "CgtsZW1wdHktdmlzaXRvcg%3D%3D", // Visitor data token
  language: "en",      // Language code (en, es, fr, etc.)
  location: "US",      // Country code (US, GB, IN, etc.)
);
```

### Cookies

For accessing user-specific content or authenticated features, you can provide cookies:

```dart
final ytMusic = YTMusic(
  cookies: "your_cookie_string_here",
);
```

### Caching

Enable database caching for improved performance:

```dart
final ytMusic = YTMusic(
  cacheDatabasePath: "/path/to/cache/database.db",
);
```

## Models

The package uses various models from the `gyawun_shared` package:

- `Page` - Contains sections and continuation data
- `Section` - Groups of related items
- `SectionItem` - Individual items (songs, albums, artists, etc.)
- `ContinuationPage` - Paginated content
- `YTSearchSuggestions` - Search autocomplete results

## Dependencies

- `gyawun_shared` - Shared models and utilities
- HTTP client for API requests
- Optional: SQLite for caching

## Performance

The package uses Dart isolates for heavy parsing operations to prevent UI blocking:

- Playlist parsing runs in isolates
- Chip page parsing runs in isolates
- Album and artist parsing optimized for speed


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This package is part of the Gyawun project.

## Credits

Developed by [Sheikh Haziq](https://github.com/sheikhhaziq) for the Gyawun music player app.

## Support

For issues, questions, or contributions, please visit the [GitHub repository](https://github.com/sheikhhaziq/ytmusic).