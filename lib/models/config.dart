class YTConfig {
  String visitorData;
  String language;
  String location;
  YTConfig({
    required this.visitorData,
    required this.language,
    required this.location,
  });

  YTConfig copyWith({
    String? visitorData,
    String? language,
    String? location,
  }) => YTConfig(
    visitorData: visitorData ?? this.visitorData,
    language: language ?? this.language,
    location: location ?? this.location,
  );
}
