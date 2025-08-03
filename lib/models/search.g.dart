// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YTSearchSuggestions _$YTSearchSuggestionsFromJson(Map<String, dynamic> json) =>
    YTSearchSuggestions(
      textItems: (json['textItems'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sectionItems: (json['sectionItems'] as List<dynamic>)
          .map((e) => YTSectionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$YTSearchSuggestionsToJson(
  YTSearchSuggestions instance,
) => <String, dynamic>{
  'textItems': instance.textItems,
  'sectionItems': instance.sectionItems,
};

YTSearchPage _$YTSearchPageFromJson(Map<String, dynamic> json) => YTSearchPage(
  sections: (json['sections'] as List<dynamic>)
      .map((e) => YTSection.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$YTSearchPageToJson(YTSearchPage instance) =>
    <String, dynamic>{'sections': instance.sections};
