import 'package:discount_and_currency_calculator/model/discount_history.dart';
import 'package:hive_flutter/hive_flutter.dart';


class HiveManager {
  static const String historyBoxName = 'historyBox';

  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DiscountHistoryAdapter());
    await Hive.openBox<DiscountHistory>(historyBoxName);
  }
}
