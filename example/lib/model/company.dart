import 'package:example/res/res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

//flutter pub run build_runner watch
@JsonSerializable(explicitToJson: true)
class Company {
  String id,
      name,
      description,
      address,
      city,
      state,
      zip,
      phone_1,
      phone_2,
      phone_3,
      sign,
      logo,
      color,
      accentColor,
      language,
      defaultCategoryId;

  Company(
      {this.id,
      this.name,
      this.description,
      this.address,
      this.city,
      this.state,
      this.zip,
      this.phone_1,
      this.phone_2,
      this.phone_3,
      this.sign,
      this.logo,
      this.color,
      this.accentColor,
      this.language,
      this.defaultCategoryId});

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  @override
  String toString() {
    return 'Company{id: $id, name: $name, description: $description, address: $address, city: $city, state: $state, zip: $zip, phone_1: $phone_1, phone_2: $phone_2, phone_3: $phone_3, sign: $sign, logo: $logo, color: $color, accentColor: $accentColor, language: $language, defaultCategoryId: $defaultCategoryId}';
  }
}

@JsonSerializable(explicitToJson: true)
class Category {
  String id, name;
  bool isDefault;
  List<Attribute> attributes;

  Category();

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  String toString() {
    return 'Category{id: $id, name: $name, attributes: $attributes}';
  }
}

enum AttributeType { TEXT, NUMBER, VIN, UPC, DROPDOWN, MULTI_SELECT, GPS }

@JsonSerializable()
class Attribute {
  String id, name, label;
  AttributeType type;
  bool isRequired,isActive;
  int orderNumber;
  List<Option> options;

  Attribute({this.id, this.name, this.label, this.type, this.isRequired, this.orderNumber, this.options, this.isActive});

  factory Attribute.fromJson(Map<String, dynamic> json) => _$AttributeFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Option {
  String id, value, attributeId;

  Option({this.id, this.value, this.attributeId});

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

  Map<String, dynamic> toJson() => _$OptionToJson(this);

  @override
  String toString() {
      return 'Option{id: $id, value: $value, attributeId: $attributeId}';
  }

}

class DefaultCompanyData {
  String sign = "\$";
  String logo = Img.icLogo;
  String color = "FF4D4D4D";
  String accentColor = "FFF7A100";
  String language = EnUSStrings().languageCode;
}
