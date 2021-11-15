import 'package:universal_io/io.dart';
import 'package:uno/src/presenter/uno_base.dart';
import 'package:uno/uno.dart';

void main() async {
  // final uno = Uno();
  // uno.interceptors.request.use((request) {
  //   request.headers['test'] = 'test';
  //   return request;
  // });
  // final response = await uno.get('https://jsonplaceholder.typicode.com/todos');
  // print(response.data);

  final uno = Uno(
    baseURL: '',
  );
  uno.interceptors.request.use((request) {
    request.headers['test'] = 'test';
    return request;
  });
  // final formData = FormData();
  // formData.add('title', 'juca');
  // formData.addFile('image', 'mvvm.png');
  // final response = await uno.post('http://localhost:3000/form', data: formData);
  // print(response.data);

  await uno(
    method: 'get',
    url: 'http://bit.ly/2mTM3nY',
    responseType: ResponseType.arraybuffer,
    onDownloadProgress: (total, current) {
      final percentCompleted = (current / total * 100).round();
      print('completed: $percentCompleted%');
    },
  ).then((response) async {
    await File('ada_lovelace.jpg').writeAsBytes(response.data);
  });
}
