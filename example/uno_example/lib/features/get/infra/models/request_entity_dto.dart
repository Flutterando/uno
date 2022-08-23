import 'dart:convert';

import '../../domain/entities/request_entity.dart';

class RequestEntityDto extends RequestEntity {
  RequestEntityDto({required super.title, required super.body, super.id, super.userId, super.status});

  factory RequestEntityDto.fromMap(Map<String, dynamic> map) {
    return RequestEntityDto(
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      id: map['id'] ?? 0,
      userId: map['userId'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'title': title});
    result.addAll({'body': body});
    result.addAll({'id': id});
    result.addAll({'userId': userId});

    return result;
  }

  String toJson() => json.encode(toMap());

  factory RequestEntityDto.fromJson(String source) =>
      RequestEntityDto.fromMap(json.decode(source));
}

