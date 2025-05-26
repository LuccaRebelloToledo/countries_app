import 'dart:async';

import 'package:dio/dio.dart';

import '../models/country.dart';

class CountryService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://restcountries.com/v3.1'));

  FutureOr<List<Country>> getAll() async {
    try {
      final response = await _dio.get('/all');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Country.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Erro ao carregar países $e');
    }
  }

  FutureOr<Country> getByName(String name) async {
    try {
      final response = await _dio.get('/name/$name');

      if (response.statusCode == 200 && (response.data as List).isNotEmpty) {
        return Country.fromJson(response.data[0]);
      }

      throw Exception('País não encontrado!');
    } catch (e) {
      throw Exception('Erro ao carregar país $name: $e');
    }
  }
}
