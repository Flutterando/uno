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

  final uno = Uno();
  uno.interceptors.request.use((request) {
    request.headers['test'] = 'test';
    return request;
  });
  // final formData = FormData();
  // formData.add('title', 'juca');
  // formData.addFile('image', 'mvvm.png');
  // final response = await uno.post('http://localhost:3000/form', data: formData);
  // print(response.data);

  final response = await uno.get(
    'http://localhost:3000/public/slidy.tar',
    responseType: ResponseType.arraybuffer,
    onDownloadProgress: (total, current) {
      final percentCompleted = (current / total * 100).round();
      print('completed: $percentCompleted%');
    },
  );
  await File('image.png').writeAsBytes(response.data);
  exit(0);
}
