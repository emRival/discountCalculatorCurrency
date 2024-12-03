class CurrencyResponse {
  final Map<String, double> data;

  CurrencyResponse({required this.data});

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as Map;
    final Map<String, double> data = {};

    // Konversi nilai menjadi double
    rawData.forEach((key, value) {
      data[key] = value is int ? value.toDouble() : value as double;
    });

    return CurrencyResponse(data: data);
  }
}
