## Examples

## Performing a GET request

```dart
final uno = Uno();

// Make a request for a user with a given ID
uno.get('/users?id=1').then((response){
  print(response.data); // it's a Map<String, dynamic>.
}).catchError((error){
  print(error) // It's a UnoError.
});

// Optionally the request above could also be done as
uno.get('/users',params: {
  'id': '1',
}).then((response){
  print(response.data);
});

// Want to use async/await? Add the `async` keyword to your outer function/method.
Future<void> getUser() async {
  try {
    final response = await uno.get('/user?ID=12345');
    print(response.data);
  } on UnoError catch (error) {
    print(error);
  }
}
```

## Performing a POST request

```dart
  uno.post('/user', data: {
    'firstName': 'Fred',
    'lastName': 'Flintstone'
  })
  .then((response) {
    print(response);
  })
  .catchError((error) {
    print(error);
  });
```

## Performing a DELETE request

```dart
 Future<RequestEntity> sendDelete(RequestEntity entity) async {
    try {
      final response = await uno
          .delete('https://jsonplaceholder.typicode.com/posts/${entity.id}');
      if (response.status != 404) {
        return RequestEntity(
            title: 'title', body: 'body', status: response.status,);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
```

## Performing a PATCH request

```dart
Future<RequestEntity> sendPatch(RequestEntity entity) async {
    try {
      final response = await uno.patch('https://jsonplaceholder.typicode.com/posts/${entity.id}');
      if (response.status != 404) {
        return RequestEntity(
          title: 'title',
          body: 'body',
          status: response.status,
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
```

## Performing a PUT request

```dart
Future<RequestEntity> sendPut(RequestEntity entity) async {
    try {
      final response = await uno.put('https://jsonplaceholder.typicode.com/posts/${entity.id}');
      if (response.status != 404) {
        return RequestEntity(
          title: 'title',
          body: 'body',
          status: response.status,
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
```

## Image donwload from server

```dart
// Download image from server;
uno(
  method: 'get',
  url: 'http://bit.ly/2mTM3nY',
  // you can use plain, json(default), arraybuffer and stream;
  responseType: ResponseType.arraybuffer,
  onDownloadProgress: (total, current) {
    final percentCompleted = (current / total * 100).round();
    print('completed: $percentCompleted%');
  },
).then((response) async {
  await File('ada_lovelace.jpg').writeAsBytes(response.data);
});
```

## Creating a Uno instance

```dart
final uno = Uno(
  baseURL: 'https://some-domain.com/api/',
  timeout: Duration(second: 30),
  headers: {'X-Custom-Header': 'foobar'}
);
```

## Uno interceptors

You can intercept requests or responses before they are handled by then or catch:

```dart
// Add a request interceptor
  uno.interceptors.request.use((request) {
    // Do something before request is sent
    return request;
  }, onError: (error) {
    // Do something with request error
    return error;
  });

  // Add a response interceptor
  uno.interceptors.response.use((response) {
    // Any status code that lie within the range of 2xx cause this function to trigger
    // Do something with response data
    return response;
  }, onError: (error) {
    // Any status codes that falls outside the range of 2xx cause this function to trigger
    // Do something with response error
    return error;
  });
```

If you need to remove an interceptor later you can.

```dart
final myInterceptor = uno.interceptors.request.use((request) {/*...*/});
uno.interceptors.request.eject(myInterceptor);
```

If you want to execute a particular interceptor based on a runtime check, you can add a runWhen function to the options object. The interceptor will not be executed if and only if the return of runWhen is false. The function will be called with the config object (don't forget that you can bind your own arguments to it as well.) This can be handy when you have an asynchronous request interceptor that only needs to run at certain times.

```dart
bool onGetCall(request) {
  return request.method == 'get';
}
uno.interceptors.request.use((request) {
  request.headers['test'] = 'special get headers';
  return request;
}, runWhen: onGetCall);
```

## Handling errors

```dart
uno.get('/user/12345')
  .catchError((error) {
    if (error.response != null) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx
      print(error.response.data);
      print(error.response.status);
      print(error.response.headers);
    } else if (error.request != null) {
      // The request was made but no response was received
      // `error.request` is an instance of XMLHttpRequest in the browser and an instance of
      // http.ClientRequest in node.js
      print(error.request);
    } else {
      // Something happened in setting up the request that triggered an Error
      print('Error ${error.message}');
    }
  });
```

Using the validateStatus config option, you can define HTTP code(s) that should throw an error.

```dart
axios.get('/user/12345', {
  validateStatus: (status) {
    return status < 500; // Resolve only if the status code is less than 500
  }
});
```

## Multipart/FormData

You can use the form-data:

```dart
final form = FormData();

form.add('my_field', 'my value');
form.addBytes('my_buffer', <int>[]);
form.addFile('my_file', 'my_file.pdf');

uno.post('https://example.com', data: form);
```
