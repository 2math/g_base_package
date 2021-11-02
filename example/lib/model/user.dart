import 'package:g_base_package/base/utils/validators.dart';
import 'package:json_annotation/json_annotation.dart';

import 'company.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  String? address;
  String? city;
  String? email;
  String? id;
  String? firstName;
  String? lastName;
  String? phone1;
  String? phone2;
  String? phone3;
  String? state;
  String? zipCode;
  List<Category>? categories;
  Company? company;


  User({this.address, this.city, this.email, this.id, this.firstName,
      this.lastName, this.phone1, this.phone2, this.phone3, this.state,
      this.zipCode});

  bool isPopulated() {
    return (!Validator.isEmpty(address) &&
        !Validator.isEmpty(city) &&
        !Validator.isEmpty(state) &&
        !Validator.isEmpty(zipCode));
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Map<String, dynamic> toJsonForUpdate() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['address'] = this.address;
      data['city'] = this.city;
      data['email'] = this.email;
      data['name'] = this.firstName;
      data['lastName'] = this.lastName;
      data['phone'] = this.phone1;
      data['state'] = this.state;
      data['zipCode'] = this.zipCode;
      return data;
  }

  @override
  String toString() {
      return 'User{address: $address, city: $city, email: $email, id: $id, firstName: $firstName, lastName: $lastName, phone1: $phone1, phone2: $phone2, phone3: $phone3, state: $state, zipCode: $zipCode, categories: $categories, company: $company}';
  }

}
