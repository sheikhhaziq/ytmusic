import 'package:json_annotation/json_annotation.dart';
import 'package:ytmusic/ytmusic.dart';

part 'search.g.dart';

@JsonSerializable()
class YTSearchSuggestions {
  List<String> textItems;
  List<YTSectionItem> sectionItems;

  YTSearchSuggestions({required this.textItems, required this.sectionItems});

  factory YTSearchSuggestions.fromJson(Map<String, dynamic> json) =>
      _$YTSearchSuggestionsFromJson(json);

  Map<String, dynamic> toJson() => _$YTSearchSuggestionsToJson(this);
}

@JsonSerializable()
class YTSearchPage {
  List<YTSection> sections;

  YTSearchPage({required this.sections});

  factory YTSearchPage.fromJson(Map<String, dynamic> json) =>
      _$YTSearchPageFromJson(json);

  Map<String, dynamic> toJson() => _$YTSearchPageToJson(this);
}
