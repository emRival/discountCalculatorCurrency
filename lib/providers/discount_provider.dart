import 'package:discount_and_currency_calculator/providers/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:discount_and_currency_calculator/model/discount_history.dart';
import 'package:discount_and_currency_calculator/providers/history_provider.dart';

class DiscountProvider extends ChangeNotifier {
  // Controllers for price and profit input
  final TextEditingController originalPriceController = TextEditingController();
  final TextEditingController profitController = TextEditingController();
  final List<TextEditingController> discountControllers = [];
  final CurrencyProvider _currencyProvider = CurrencyProvider();

  // Currency-related state
  String _selectedCurrency = 'IDR'; // Default currency
  String _selectedCurrencyOnline = 'IDR'; // Default currency

  final List<Map<String, String>> _currencySymbols = [
    {"currency": "USD", "symbol": "\$", "flag": "🇺🇸"},
    {"currency": "EUR", "symbol": "€", "flag": "🇪🇺"},
    {"currency": "IDR", "symbol": "Rp", "flag": "🇮🇩"},
    {"currency": "JPY", "symbol": "¥", "flag": "🇯🇵"},
    {"currency": "CNY", "symbol": "¥", "flag": "🇨🇳"},
    {"currency": "KRW", "symbol": "₩", "flag": "🇰🇷"},
  ];

  final Map<String, String> _currencyFormats = {
    'USD': 'en_US',
    'EUR': 'de_DE',
    'IDR': 'id_ID',
    'JPY': 'ja_JP',
    'CNY': 'zh_CN',
    'KRW': 'ko_KR',
  };

  // Get flag and name currency by currency ['flag']['currency']
  String getFlagByCurrency(String currency) {
    String flag =
        _currencySymbols.firstWhere((e) => e['currency'] == currency)['flag'] ??
            '';
    return "$flag $currency";
  }

  // Update currency and calculate after exchange
  void updateCurrencyOnline(String newCurrency) {
    _selectedCurrencyOnline = newCurrency;

    // Update the currency formatter for the selected currency
    notifyListeners();

    // Calculate the price after exchange
    _calculatePriceAfterExchange();
  }

  // Calculate final price and sell price after exchange
  void _calculatePriceAfterExchange() {
    if (_currencyProvider.rates.isNotEmpty) {
      // Get exchange rate for the selected currency
      double rate = _currencyProvider.rates[_selectedCurrencyOnline] ?? 1.0;

      // Calculate final price after conversion
      finalPriceAfterExchange = (finalPrice ?? 0) * rate;

      // Calculate sell price after conversion
      sellPriceAfterExchange = (sellPrice ?? 0) * rate;

      // Notify listeners to update UI
      notifyListeners();
    }
  }

  // Getters for currencies and formatting
  List<Map<String, String>> get currencies => _currencySymbols;
  String get selectedCurrency => _selectedCurrency;
  String get selectedCurrencyOnline => _selectedCurrencyOnline;
  String get currencySymbol =>
      _currencySymbols
          .firstWhere((e) => e['currency'] == _selectedCurrency)['symbol'] ??
      '';
  String get currencySymbolOnline =>
      _currencySymbols.firstWhere(
          (e) => e['currency'] == _selectedCurrencyOnline)['symbol'] ??
      '';
  String get currencyFormat => _currencyFormats[_selectedCurrency] ?? 'id_ID';
  String get currencyFormatOnline =>
      _currencyFormats[_selectedCurrencyOnline] ?? 'id_ID';

  // Currency formatter dynamically based on selected currency
  NumberFormat get currencyFormatter => NumberFormat.currency(
        locale: currencyFormat,
        symbol: currencySymbol,
        decimalDigits: 0,
      );
  NumberFormat get currencyFormatterOnline => NumberFormat.currency(
        locale: currencyFormatOnline,
        symbol: currencySymbolOnline,
        decimalDigits: (currencyFormatOnline == 'en_US' || currencyFormatOnline == 'de_DE') ? 2 : 0,
      );
  double? finalPrice;
  double? sellPrice;
  double? finalPriceAfterExchange;
  double? sellPriceAfterExchange;

  // Add a new discount field
  void addDiscountField() {
    discountControllers.add(TextEditingController());
    notifyListeners();
  }

  // Remove a discount field by index
  void removeDiscountField(int index) {
    discountControllers.removeAt(index);
    notifyListeners();
  }

  // Update selected currency
  void updateCurrency(String newCurrency) {
    _selectedCurrency = newCurrency;
    _selectedCurrencyOnline = newCurrency;
    _currencyProvider.updateBaseCurrency(newCurrency);

    // Clear all calculated prices when currency changes
    finalPrice = null;
    sellPrice = null;
    finalPriceAfterExchange = null;
    sellPriceAfterExchange = null;

    // Notify listeners to update UI
    notifyListeners();

    // Update currency for all fields
    _updateCurrencyForAllFields();
  }

  // Update all fields when currency is changed
  void _updateCurrencyForAllFields() {
    originalPriceController.text = formatPrice(originalPriceController.text);
    profitController.text = formatPrice(profitController.text);

    if (finalPrice != null) {
      finalPrice = _parseInput(originalPriceController.text);
      sellPrice = finalPrice! + _parseInput(profitController.text);
    }

    // Update after exchange prices
    _updateExchangeRates();
  }

  // Update after exchange prices
  void _updateExchangeRates() {
    if (_currencyProvider.rates.isNotEmpty) {
      double exchangeRate =
          _currencyProvider.rates[_selectedCurrencyOnline] ?? 1.0;
      finalPriceAfterExchange = finalPrice! * exchangeRate;
      sellPriceAfterExchange = sellPrice! * exchangeRate;
    }
  }

  // Format price based on selected currency
  String formatPrice(String value) {
    final formattedValue = currencyFormatter.format(_parseInput(value));
    return formattedValue;
  }

  // Calculate the final price after discounts and profit
  void calculateFinalPrice() {
    double originalPrice = _parseInput(originalPriceController.text);
    double result = originalPrice;

    for (var controller in discountControllers) {
      double discount = _parseInput(controller.text);
      result -= result * (discount / 100);
    }

    double profit = _parseInput(profitController.text);
    sellPrice = result + profit;
    finalPrice = result;

    _saveHistory(); // Save calculation history to Hive box
    notifyListeners();
  }

  // Format profit value dynamically
  String formatProfit(String value) {
    final formattedValue = currencyFormatter.format(_parseInput(value));
    profitController.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
    return formattedValue;
  }

  // Format original price
  String formatOriginalPrice(String value) {
    final formattedValue = currencyFormatter.format(_parseInput(value));
    originalPriceController.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
    return formattedValue;
  }

  // Parse input string to double (removes non-numeric characters)
  double _parseInput(String input) {
    return double.tryParse(input.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
  }

  // Save calculation history to Hive box
  Future<void> _saveHistory() async {
    final history = DiscountHistory(
      date: DateFormat('dd MMMM yyyy').format(DateTime.now()),
      originalPrice:
          currencyFormatter.format(_parseInput(originalPriceController.text)),
      discount: discountControllers.map((c) => '${c.text}%').join(', '),
      finalPrice: currencyFormatter.format(finalPrice),
      profit: currencyFormatter.format(_parseInput(profitController.text)),
      sellPrice: currencyFormatter.format(sellPrice),
    );

    HistoryProvider(
      Hive.box<DiscountHistory>('historyBox'),
    ).addHistory(history);
  }
}
