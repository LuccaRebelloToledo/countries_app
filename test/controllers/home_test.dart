import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:rest_countries/controllers/home.dart';
import 'package:rest_countries/models/country.dart';
import '../services/country_test.mocks.dart';

void main() {
  // Inicializa o binding necessário para testes com widgets e GetX.
  TestWidgetsFlutterBinding.ensureInitialized(); // Sem isso, alguns recursos do Flutter/GetX não funcionam nos testes.

  late MockCountryService mockCountryService;
  late HomeController controller;

  // Antes dos testes, criamos um novo mock e um novo controller.
  setUp(() {
    mockCountryService = MockCountryService();
    controller = HomeController(mockCountryService);
    Get.testMode =
        true; // Ativamos o modo de teste do GetX para evitar problemas com UI.
  });

  group('Cenário 01 | Listagem bem-sucedida', () {
    test('A lista de países é retornada corretamente', () async {
      final countries = [
        Country(
          name: 'Brasil',
          officialName: 'República Federativa do Brasil',
          flag: 'url_brasil',
          capital: ['Brasília'],
          region: 'América do Sul',
          subregion: 'América do Sul',
          population: 210000000,
          timezones: ['UTC-3'],
          continents: ['South America'],
          languages: {'por': 'Português'},
          currencies: {
            'BRL': {'name': 'Real', 'symbol': 'R\$'},
          },
          googleMapsUrl: 'https://maps.google.com/?q=Brazil',
        ),
        Country(
          name: 'Argentina',
          officialName: 'República Argentina',
          flag: 'url_arg',
          capital: ['Buenos Aires'],
          region: 'América do Sul',
          subregion: 'América do Sul',
          population: 45000000,
          timezones: ['UTC-3'],
          continents: ['South America'],
          languages: {'spa': 'Espanhol'},
          currencies: {
            'ARS': {'name': 'Peso', 'symbol': 'AR\$'},
          },
          googleMapsUrl: 'https://maps.google.com/?q=Argentina',
        ),
      ];

      // Configuramos o método getAll do serviço para que a resposta seja a lista com os dados mockados.
      when(mockCountryService.getAll()).thenAnswer((_) async => countries);

      await controller.fetchCountries();

      // Validações se a lista de países foi preenchida com os dados mockados.
      expect(controller.allCountries.isNotEmpty, true);
      expect(controller.allCountries.first.name, 'Brasil');
      expect(controller.allCountries.first.capital.first, 'Brasília');
      expect(controller.allCountries.first.flag, 'url_brasil');
    });
  });

  group('Cenário 02 | Erro na requisição de países', () {
    test('A exceção é lançada corretamente', () async {
      // Configuramos o método getAll do serviço para lançar um erro ao ser chamado.
      when(mockCountryService.getAll()).thenThrow(Exception('API fora do ar'));
      controller.fetchCountries();

      // Verificamos se a lista de países está vazia para validarmos nosso erro mockado.
      expect(controller.allCountries.isEmpty, true);
    });
  });

  group('Cenário 03 | Busca de país por nome com resultado', () {
    test(
      'Os detalhes de um país específico são retornados corretamente',
      () async {
        final country = Country(
          name: 'Brasil',
          officialName: 'República Federativa do Brasil',
          flag: 'url_brasil',
          capital: ['Brasília'],
          region: 'América do Sul',
          subregion: 'América do Sul',
          population: 210000000,
          timezones: ['UTC-3'],
          continents: ['South America'],
          languages: {'por': 'Português'},
          currencies: {
            'BRL': {'name': 'Real', 'symbol': 'R\$'},
          },
          googleMapsUrl: 'https://maps.google.com/?q=Brazil',
        );

        // Configuramos o método getByName do serviço para retornar o país específico mockado.
        when(
          mockCountryService.getByName('Brasil'),
        ).thenAnswer((_) async => country);

        final result = await controller.fetchCountryDetails('Brasil');
        // Verificamos se o resultado correspondo com o país mockado.
        expect(result, isNotNull);
        expect(result.name, 'Brasil');
        expect(result.capital.first, 'Brasília');
        expect(result.population, 210000000);
      },
    );
  });

  group('Cenário 04 | Busca de país por nome com resultado vazio', () {
    test('Lança erro controlado ao buscar país inexistente', () async {
      // Configuramos o método getByName do serviço para lançar uma exceção para quando um país não for encontrado, ou seja, Narnia.
      when(
        mockCountryService.getByName('Narnia'),
      ).thenThrow(Exception('País não encontrado'));

      // Verificamos se a chamada ao método fetchCountryDetails lança uma exceção.
      expect(() => controller.fetchCountryDetails('Narnia'), throwsException);
    });
  });

  group('Cenário 05 | País com dados incompletos', () {
    test('App lida com país sem capital ou sem bandeira', () async {
      final country = Country(
        name: 'PaísX',
        officialName: 'PaísX Oficial',
        flag: '',
        capital: [],
        region: 'Desconhecido',
        subregion: '',
        population: 1000,
        timezones: [],
        continents: [],
        languages: {},
        currencies: null,
        googleMapsUrl: null,
      );
      // Configuramos o método getAll do serviço para retornar o país mockado com dados incompletos.
      when(mockCountryService.getAll()).thenAnswer((_) async => [country]);
      await controller.fetchCountries();

      // Verificamos se o país foi adicionado à lista de países e se os campos incompletos estão vazios, assim como está no dado mockado.
      expect(controller.allCountries.first.capital.isEmpty, true);
      expect(controller.allCountries.first.flag, '');
    });
  });

  group('Cenário 06 | Verificar chamada ao método', () {
    test('Método getAll() foi chamado', () async {
      // Configuramos o método getAll do serviço para retornar uma lista vazia.
      when(mockCountryService.getAll()).thenAnswer((_) async => []);
      await controller.fetchCountries();

      // Após chamar o método fetchCountries, verificamos se o método getAll foi chamado uma vez.
      verify(mockCountryService.getAll()).called(1);
    });
  });
}
