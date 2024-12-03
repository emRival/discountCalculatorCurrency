import 'package:hive/hive.dart';

part 'discount_history.g.dart';

@HiveType(typeId: 0)
class DiscountHistory extends HiveObject {
  @HiveField(0)
  final String date;
  @HiveField(1)
  final String originalPrice;
  @HiveField(2)
  final String discount;
  @HiveField(3)
  final String finalPrice;
  @HiveField(4)
  final String profit;
  @HiveField(5)
  final String sellPrice;

  DiscountHistory({
    required this.date,
    required this.originalPrice,
    required this.discount,
    required this.finalPrice,
    required this.profit,
    required this.sellPrice,
  });
}
