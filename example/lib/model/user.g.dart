// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      address: json['address'] as String?,
      city: json['city'] as String?,
      email: json['email'] as String?,
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phone1: json['phone1'] as String?,
      phone2: json['phone2'] as String?,
      phone3: json['phone3'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
    )
      ..categories = (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList()
      ..company = json['company'] == null
          ? null
          : Company.fromJson(json['company'] as Map<String, dynamic>);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'email': instance.email,
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone1': instance.phone1,
      'phone2': instance.phone2,
      'phone3': instance.phone3,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'categories': instance.categories?.map((e) => e.toJson()).toList(),
      'company': instance.company?.toJson(),
    };
