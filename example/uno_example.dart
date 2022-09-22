import 'package:flutter/material.dart';
import 'package:uno/uno.dart';

void main() async {
  final uno = Uno();
  final response = await uno.get(
    'http://localhost:8080/spoiler.png',
    responseType: ResponseType.arraybuffer,
  );
  debugPrint(response.data);

  //final uno = Uno();

  // final formData = FormData();
  // formData.add('title', 'juca');
  // formData.addFile('image', 'mvvm.png');
  // final response = await uno.post('http://localhost:3000/form', data: formData);
  // print(response.data);

  // await uno(
  //   method: 'get',
  //   url: 'http://bit.ly/2mTM3nY',
  //   responseType: ResponseType.arraybuffer,
  //   onDownloadProgress: (total, current) {
  //     final percentCompleted = (current / total * 100).round();
  //     print('completed: $percentCompleted%');
  //   },
  // ).then((response) async {
  //   await File('ada_lovelace.jpg').writeAsBytes(response.data);
  // });
}
