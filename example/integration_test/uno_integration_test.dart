import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:uno/uno.dart';
import 'package:uno_example/app_module.dart';
import 'package:uno_example/features/get/external/datasources/send_get_datasource_impl.dart';
import 'package:uno_example/features/get/infra/implementations/get_facts_usecase_impl.dart';
import 'package:uno_example/features/get/infra/implementations/send_get_repository_impl.dart';
import 'package:uno_example/main.dart';

class UnoMock extends Mock implements Uno {}

class SendGetDataSourceMock extends Mock implements SendGetDataSource {}

class SendGetRepositoryMock extends Mock implements SendGetRepository {}

class SendGetUseCaseMock extends Mock implements GetFactsUseCase {}

void main() {
  final unoMock = UnoMock();
  final sendGetMock = SendGetDataSourceMock();
  final sendRepositoryMock = SendGetRepositoryMock();
  final sendUseCaseMock = SendGetUseCaseMock();

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(
    () {
      initModule(
        AppModule(),
        replaceBinds: [
          Bind.instance<Uno>(unoMock),
          Bind.instance<SendGetDataSource>(sendGetMock),
          Bind.instance<SendGetRepository>(sendRepositoryMock),
          Bind.instance<GetFactsUseCase>(sendUseCaseMock),
        ],
      );
    },
  );

  testWidgets('Test if info from get appears', (tester) async {
    const content =
        '''sunt aut facere repellat provident occaecati excepturi optio reprehenderit''';
    await tester.pumpWidget(buildScreen());

    final textFinder = find.text(content);
    await tester.pumpAndSettle();
    expect(textFinder, findsOneWidget);
  });

  testWidgets(
    'Should send a POST request when click the button',
    (tester) async {
      const content = 'http status response:201';
      await tester.pumpWidget(buildScreen());

      // Create the Finders.
      final btnFinder = find.text('Post test');
      await tester.tap(btnFinder);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      final textFinder = find.text(content);
      expect(textFinder, findsWidgets);
    },
  );

  testWidgets(
    'Should send a DELETE request when click the button',
    (tester) async {
      const content = 'http status response:200';
      await tester.pumpWidget(buildScreen());

      // Create the Finders.
      final btnFinder = find.text('Delete test');
      await tester.tap(btnFinder);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      final textFinder = find.text(content);
      expect(textFinder, findsWidgets);
    },
  );

  testWidgets(
    'Should send a PATCH request when click the button',
    (tester) async {
      const content = 'http status response:200';
      await tester.pumpWidget(buildScreen());

      // Create the Finders.
      final btnFinder = find.text('Patch test');
      await tester.tap(btnFinder);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      final textFinder = find.text(content);
      expect(textFinder, findsWidgets);
    },
  );

  testWidgets(
    'Should send a PUT request when click the button',
    (tester) async {
      const content = 'http status response:200';
      await tester.pumpWidget(buildScreen());

      // Create the Finders.
      final btnFinder = find.text('Put test');
      await tester.tap(btnFinder);
      final gesture = await tester.startGesture(const Offset(0, 300));
      await gesture.moveBy(const Offset(0, -300));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 3));
      final textFinder = find.text(content);
      expect(textFinder, findsWidgets);
    },
  );
}

MaterialApp buildScreen() {
  return MaterialApp(
    title: 'Uno Demo',
    theme: ThemeData(
      primarySwatch: Colors.grey,
    ),
    home: const MyHomePage(title: 'Uno Demo'),
  );
}
