import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home.dart';
import 'country_detail.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Países'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar país por nome',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _searchCountry(value.trim());
                }
              },
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.visibleCountries.isEmpty) {
          return Center(child: Text('Nenhum país encontrado'));
        }

        return ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.visibleCountries.length,
          itemBuilder: (_, index) {
            final country = controller.visibleCountries[index];
            return GestureDetector(
              onTap: () async {
                // busca detalhada pelo nome e navega
                try {
                  Get.dialog(
                    Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );
                  final detailedCountry = await controller.fetchCountryDetails(
                    country.name,
                  );
                  Get.back();
                  Get.to(() => CountryDetailPage(country: detailedCountry));
                } catch (e) {
                  Get.back();
                  Get.snackbar('Erro', 'Não foi possível carregar detalhes');
                }
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Image.network(
                    country.flag,
                    width: 50,
                    height: 50,
                    errorBuilder: (_, __, ___) => Icon(Icons.flag),
                  ),
                  title: Text(country.name),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _searchCountry(String name) async {
    try {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final country = await controller.fetchCountryDetails(name);
      Get.back();
      Get.to(() => CountryDetailPage(country: country));
    } catch (e) {
      Get.back();
      Get.snackbar('Erro', 'País não encontrado');
    }
  }
}
