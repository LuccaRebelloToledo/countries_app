import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:rest_countries/models/country.dart';

class CountryDetailPage extends StatelessWidget {
  final Country country;
  const CountryDetailPage({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    String currenciesStr = '';
    if (country.currencies != null) {
      currenciesStr = country.currencies!.entries
          .map((e) => '${e.value['name']} (${e.value['symbol'] ?? ''})')
          .join(', ');
    }

    return Scaffold(
      appBar: AppBar(title: Text(country.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(country.flag, width: 200),
            ),
            SizedBox(height: 16),
            Text('Nome oficial: ${country.officialName}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Capital: ${country.capital.isNotEmpty ? country.capital.join(', ') : 'N/A'}'),
            Text('Região: ${country.region}'),
            Text('Sub-região: ${country.subregion}'),
            Text('Continentes: ${country.continents.join(', ')}'),
            Text('População: ${country.population}'),
            Text('Fuso horário(s): ${country.timezones.join(', ')}'),
            Text('Idiomas: ${country.languages.values.join(', ')}'),
            Text('Moeda(s): ${currenciesStr.isNotEmpty ? currenciesStr : 'N/A'}'),
            SizedBox(height: 16),
            if (country.googleMapsUrl != null)
              ElevatedButton.icon(
                icon: Icon(Icons.map),
                label: Text('Abrir no Google Maps'),
                onPressed: () async {
                  final url = Uri.parse(country.googleMapsUrl!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Não foi possível abrir o link')),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
