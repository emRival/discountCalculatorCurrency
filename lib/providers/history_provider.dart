import 'package:discount_and_currency_calculator/model/discount_history.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class HistoryProvider with ChangeNotifier {
  final Box<DiscountHistory> _historyBox;

  HistoryProvider(this._historyBox);

  List<DiscountHistory> get historyList => _historyBox.values.toList();

  Future<void> addHistory(DiscountHistory history) async {
    await _historyBox.add(history);
    notifyListeners();
  }

  Future<void> deleteHistory(int index) async {
    await _historyBox.deleteAt(index);
    notifyListeners();
  }

  Future<void> clearAllHistory() async {
    await _historyBox.clear();
    notifyListeners();
  }
}
