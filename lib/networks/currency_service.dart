import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/currency_response.dart';


class CurrencyService {
  final String apiKey = 'sgiPfh4j3aXFR3l2CnjWqdKQzxpqGn9pX5b3CUsz';
  final String baseUrl = 'https://api.freecurrencyapi.com/v1/latest';

  Future<CurrencyResponse> fetchRates({required String baseCurrency}) async {
    final Uri url = Uri.parse(
        '$baseUrl?apikey=$apiKey&currencies=USD,EUR,IDR,JPY,CNY,KRW&base_currency=$baseCurrency');

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return CurrencyResponse.fromJson(json);
    } else {
      throw Exception('Failed to fetch currency rates');
    }
  }
}
