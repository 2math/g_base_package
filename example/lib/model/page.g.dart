// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page _$PageFromJson(Map<String, dynamic> json) {
  return Page(
    content: json['content'] as String,
    header: json['header'] as String,
    id: json['id'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
      'content': instance.content,
      'header': instance.header,
      'id': instance.id,
      'name': instance.name,
    };
