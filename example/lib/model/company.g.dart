// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) {
  return Company(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    address: json['address'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    zip: json['zip'] as String,
    phone_1: json['phone_1'] as String,
    phone_2: json['phone_2'] as String,
    phone_3: json['phone_3'] as String,
    sign: json['sign'] as String,
    logo: json['logo'] as String,
    color: json['color'] as String,
    accentColor: json['accentColor'] as String,
    language: json['language'] as String,
    defaultCategoryId: json['defaultCategoryId'] as String,
  );
}

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
      'phone_1': instance.phone_1,
      'phone_2': instance.phone_2,
      'phone_3': instance.phone_3,
      'sign': instance.sign,
      'logo': instance.logo,
      'color': instance.color,
      'accentColor': instance.accentColor,
      'language': instance.language,
      'defaultCategoryId': instance.defaultCategoryId,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..isDefault = json['isDefault'] as bool
    ..attributes = (json['attributes'] as List)
        ?.map((e) =>
            e == null ? null : Attribute.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isDefault': instance.isDefault,
      'attributes': instance.attributes?.map((e) => e?.toJson())?.toList(),
    };

Attribute _$AttributeFromJson(Map<String, dynamic> json) {
  return Attribute(
    id: json['id'] as String,
    name: json['name'] as String,
    label: json['label'] as String,
    type: _$enumDecodeNullable(_$AttributeTypeEnumMap, json['type']),
    isRequired: json['isRequired'] as bool,
    orderNumber: json['orderNumber'] as int,
    options: (json['options'] as List)
        ?.map((e) =>
            e == null ? null : Option.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    isActive: json['isActive'] as bool,
  );
}

Map<String, dynamic> _$AttributeToJson(Attribute instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'label': instance.label,
      'type': _$AttributeTypeEnumMap[instance.type],
      'isRequired': instance.isRequired,
      'isActive': instance.isActive,
      'orderNumber': instance.orderNumber,
      'options': instance.options,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$AttributeTypeEnumMap = {
  AttributeType.TEXT: 'TEXT',
  AttributeType.NUMBER: 'NUMBER',
  AttributeType.VIN: 'VIN',
  AttributeType.UPC: 'UPC',
  AttributeType.DROPDOWN: 'DROPDOWN',
  AttributeType.MULTI_SELECT: 'MULTI_SELECT',
  AttributeType.GPS: 'GPS',
};

Option _$OptionFromJson(Map<String, dynamic> json) {
  return Option(
    id: json['id'] as String,
    value: json['value'] as String,
    attributeId: json['attributeId'] as String,
  );
}

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'attributeId': instance.attributeId,
    };
