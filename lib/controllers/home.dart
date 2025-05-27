import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rest_countries/models/country.dart';
import 'package:rest_countries/services/country.dart';

class HomeController extends GetxController {
  final CountryService _countryService = CountryService();

  var allCountries = <Country>[].obs;
  var visibleCountries = <Country>[].obs;
  var isLoading = false.obs;
  final int pageSize = 15;
  int currentIndex = 0;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchCountries();
    scrollController.addListener(_onScroll);
  }

  void fetchCountries() async {
    try {
      isLoading(true);
      allCountries.value = await _countryService.getAll();
      loadMore();
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar os países');
    } finally {
      isLoading(false);
    }
  }

  Future<Country> fetchCountryDetails(String name) async {
    try {
      final country = await _countryService.getByName(name);

      return country;
    } catch (e) {
      throw Exception('Erro ao buscar país $name');
    }
  }

  void loadMore() {
    final nextItems = allCountries.skip(currentIndex).take(pageSize).toList();

    visibleCountries.addAll(nextItems);
    currentIndex += pageSize;
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (currentIndex < allCountries.length) {
        loadMore();
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
