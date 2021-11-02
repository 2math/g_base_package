import 'package:json_annotation/json_annotation.dart';

// part 'page.g.dart';

@JsonSerializable(explicitToJson: true)
class Page {
  String? content;
  String? header;
  String? id;
  String? name;

  Page({
    this.content,
    this.header,
    this.id,
    this.name,
  });

  // factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$PageToJson(this);

  @override
  String toString() {
    return 'Page{content: $content, header: $header, id: $id, name: $name}';
  }
}
