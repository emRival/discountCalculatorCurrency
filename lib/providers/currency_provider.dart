import 'package:discount_and_currency_calculator/model/currency_response.dart';
import 'package:flutter/material.dart';

import '../networks/currency_service.dart';

class CurrencyProvider extends ChangeNotifier {
  CurrencyProvider() {
    fetchRates();
  }
  final CurrencyService _currencyService = CurrencyService();

  final List<String> _allCurrencies = [
    'USD',
    'EUR',
    'IDR',
    'JPY',
    'CNY',
    'KRW'
  ];

  String _baseCurrency = 'IDR';
  Map<String, double> _filteredRates = {};
  bool _isLoading = false;

  String get baseCurrency => _baseCurrency;
  Map<String, double> get rates => _filteredRates;
  bool get isLoading => _isLoading;

  // Update base currency
  void updateBaseCurrency(String currency) {
    _baseCurrency = currency;
    fetchRates();
  }

  // Fetch and filter rates
  Future<void> fetchRates() async {
    _isLoading = true;
    notifyListeners();

    try {
      final CurrencyResponse response =
          await _currencyService.fetchRates(baseCurrency: _baseCurrency);

      // Filter out the base currency from results
      _filteredRates = response.data
        ..removeWhere((key, value) => key == _baseCurrency);

      // print response
      print(response.data);
    } catch (error) {
      _filteredRates = {};
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
