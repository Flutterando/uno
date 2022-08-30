import 'dart:convert';

import '../../../get/domain/entities/request_entity.dart';

class PostEntityDto extends RequestEntity {
  PostEntityDto({
    required super.title,
    required super.body,
    super.id,
    super.userId,
  });

  factory PostEntityDto.fromMap(Map<String, dynamic> map) {
    return PostEntityDto(
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      id: map['id'] ?? 0,
      userId: map['userId'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    // ignore: cascade_invocations
    result
      ..addAll({'title': title})
      ..addAll({'body': body})
      ..addAll({'id': id})
      ..addAll({'userId': userId});

    return result;
  }

  String toJson() => json.encode(toMap());

  factory PostEntityDto.fromJson(String source) => PostEntityDto.fromMap(
        json.decode(source),
      );
}
