class Country {
  final String name;
  final String officialName;
  final String flag;
  final List<String> capital;
  final String region;
  final String subregion;
  final int population;
  final List<String> timezones;
  final List<String> continents;
  final Map<String, String> languages;
  final Map<String, dynamic>? currencies;
  final String? googleMapsUrl;

  Country({
    required this.name,
    required this.officialName,
    required this.flag,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    required this.timezones,
    required this.continents,
    required this.languages,
    this.currencies,
    this.googleMapsUrl,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] ?? 'N/A',
      officialName: json['name']['official'] ?? 'N/A',
      flag: json['flags']['png'] ?? '',
      capital: (json['capital'] as List?)?.map((e) => e.toString()).toList() ?? [],
      region: json['region'] ?? 'N/A',
      subregion: json['subregion'] ?? 'N/A',
      population: json['population'] ?? 0,
      timezones: (json['timezones'] as List?)?.map((e) => e.toString()).toList() ?? [],
      continents: (json['continents'] as List?)?.map((e) => e.toString()).toList() ?? [],
      languages: (json['languages'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v.toString())) ?? {},
      currencies: json['currencies'],
      googleMapsUrl: json['maps']?['googleMaps'],
    );
  }
}
