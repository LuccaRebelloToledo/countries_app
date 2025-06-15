import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:rest_countries/controllers/home.dart';
import 'package:rest_countries/models/country.dart';
import 'package:rest_countries/pages/home.dart';
import '../services/country_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockCountryService mockService;
  final mockCountry = Country(
    name: 'Brasil',
    officialName: 'República Federativa do Brasil',
    flag: 'https://flagcdn.com/br.svg',
    capital: ['Brasília'],
    region: 'Americas',
    subregion: 'South America',
    continents: ['South America'],
    population: 211000000,
    timezones: ['UTC-03:00'],
    languages: {'por': 'Portuguese'},
    currencies: {
      'BRL': {'name': 'Brazilian real', 'symbol': 'R\$'},
    },
    googleMapsUrl: 'https://goo.gl/maps/waCKk21HeeqFzkNC9',
  );

  setUp(() {
    mockService = MockCountryService();
    when(mockService.getAll()).thenAnswer((_) async => [mockCountry]);
    when(mockService.getByName(any)).thenAnswer((_) async => mockCountry);
    Get.reset();
    Get.lazyPut(() => HomeController(mockService));
  });

  Future<void> pumpHomePage(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        title: 'Rest Countries App',
        debugShowCheckedModeBanner: false,
        locale: const Locale('pt', 'BR'),
        home: HomePage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Cenário 01 – Verificar se o nome do país é carregado no componente',
    (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpHomePage(tester);
        expect(find.text('Brasil'), findsOneWidget);
      });
    },
  );

  testWidgets(
    'Cenário 02 – Verificar se ao clicar em um país os dados são abertos',
    (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpHomePage(tester);
        await tester.tap(find.text('Brasil'));
        await tester.pumpAndSettle();

        expect(
          find.text('Nome oficial: República Federativa do Brasil'),
          findsOneWidget,
        );
        expect(find.text('Capital: Brasília'), findsOneWidget);
      });
    },
  );

  testWidgets(
    'Cenário 03 – Verificar se um componente de imagem é carregado com a bandeira',
    (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpHomePage(tester);
        final imageFinder = find.byType(Image);
        expect(imageFinder, findsWidgets);
        final Image imageWidget = tester.widget<Image>(imageFinder.first);
        expect(
          (imageWidget.image as NetworkImage).url,
          equals('https://flagcdn.com/br.svg'),
        );
      });
    },
  );
}
