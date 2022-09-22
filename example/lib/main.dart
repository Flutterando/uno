import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:uno_example/app_module.dart';
import 'package:uno_example/features/get/domain/entities/request_entity.dart';
import 'package:uno_example/features/get/presentation/send_get_store.dart';
import 'package:uno_example/features/patch/presentation/send_patch_store.dart';

import 'features/delete/presentation/send_delete_store.dart';
import 'features/post/presentation/send_post_store.dart';
import 'features/put/presentations/send_put_store.dart';

void main() {
  runApp(ModularApp(
    module: AppModule(),
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uno Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Uno Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    store.getFacts();
  }

  final store = Modular.get<GetFactStore>();
  final storeBtnPost = Modular.get<SendPostStore>();
  final storeBtnDelete = Modular.get<SendDeleteStore>();
  final storeBtnPatch = Modular.get<SendPatchStore>();
  final storeBtnPut = Modular.get<SendPutStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uno Example'),
      ),
      body: ScopedBuilder<GetFactStore, Exception, List<dynamic>>(
        store: store,
        onError: (_, Exception? error) {
          return const Center(
            child: Icon(
              Icons.search_off_rounded,
              size: 150,
            ),
          );
        },
        onLoading: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
        onState: (_, List state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                const Text(
                  'Get with Uno Example:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 15),
                const Text(
                  'UserId',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 15),
                Text(
                  state[0].userId.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Id',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 15),
                Text(
                  state[0].id.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Title',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 15),
                Text(
                  state[0].title.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Body',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 15),
                Text(
                  state[0].body.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                ScopedBuilder<SendPostStore, Exception, RequestEntity>(
                  store: storeBtnPost,
                  onError: (_, Exception? error) {
                    return const Center(
                      child: Icon(
                        Icons.search_off_rounded,
                        size: 150,
                      ),
                    );
                  },
                  onLoading: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  onState: (context, state) {
                    return Column(
                      children: [
                        ElevatedButton(
                            onPressed: storeBtnPost.sendPost,
                            child: const Text('Post test'),),
                        Text('http status response:${state.status}'),
                      ],
                    );
                  },
                ),
                ScopedBuilder<SendDeleteStore, Exception, RequestEntity>(
                  store: storeBtnDelete,
                  onError: (_, Exception? error) {
                    return const Center(
                      child: Icon(
                        Icons.search_off_rounded,
                        size: 150,
                      ),
                    );
                  },
                  onLoading: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  onState: (context, state) {
                    return Column(
                      children: [
                        ElevatedButton(
                            onPressed: storeBtnDelete.sendDelete,
                            child: const Text('Delete test'),),
                        Text('http status response:${state.status}'),

                      ],
                    );
                  },
                ),
                ScopedBuilder<SendPatchStore, Exception, RequestEntity>(
                  store: storeBtnPatch,
                  onError: (_, Exception? error) {
                    return const Center(
                      child: Icon(
                        Icons.search_off_rounded,
                        size: 150,
                      ),
                    );
                  },
                  onLoading: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  onState: (context, state) {
                    return Column(
                      children: [
                        ElevatedButton(
                            onPressed: storeBtnPatch.sendPatch,
                            child: const Text('Patch test'),),
                        Text('http status response:${state.status}'),

                      ],
                    );
                  },
                ),
                ScopedBuilder<SendPutStore, Exception, RequestEntity>(
                  store: storeBtnPut,
                  onError: (_, Exception? error) {
                    return const Center(
                      child: Icon(
                        Icons.search_off_rounded,
                        size: 150,
                      ),
                    );
                  },
                  onLoading: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  onState: (context, state) {
                    return Column(
                      children: [
                        ElevatedButton(
                            onPressed: storeBtnPut.sendPut,
                            child: const Text('Put test'),),
                        Text('http status response:${state.status}'),

                        const SizedBox(
                          height: 15,
                        ),
                        const Text('API powered by {JSON} Placeholder',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),)
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
