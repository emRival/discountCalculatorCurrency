import 'package:device_preview/device_preview.dart';
import 'package:discount_and_currency_calculator/model/discount_history.dart';
import 'package:discount_and_currency_calculator/pages/navigation.dart';
import 'package:discount_and_currency_calculator/providers/currency_provider.dart';
import 'package:discount_and_currency_calculator/providers/discount_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'database/hive_manager.dart';
import 'providers/history_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveManager.initializeHive();

  runApp(
    DevicePreview(
      isToolbarVisible: !(defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android),
      defaultDevice: Devices.ios.iPhone13ProMax,
      enabled: true,
      builder: (context) =>  MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => DiscountProvider()),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(
              Hive.box<DiscountHistory>(HiveManager.historyBoxName)),
        ),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
      ], child: const DiscountCalculatorApp()),
    ),
  );
}

class DiscountCalculatorApp extends StatelessWidget {
  const DiscountCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Discount Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyNavigation(),
    );
  }
}
