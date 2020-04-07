import 'package:example/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

import 'company.dart';

part 'session.g.dart';

@JsonSerializable(explicitToJson: true)
class Session {
  String sessionId;
  User user;

  Company get company {
    return user?.company ?? null;
  }

  Session({this.sessionId, this.user});

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);

  @override
  String toString() {
    return 'Session{sessionId: $sessionId,\nuser: ${user.toString()}}';
  }
}
