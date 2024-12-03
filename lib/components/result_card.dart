import 'package:discount_and_currency_calculator/providers/discount_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import provider

class ResultCard extends StatelessWidget {
  final double finalPrice;
  final double sellPrice;

  const ResultCard(
      {required this.finalPrice, required this.sellPrice, super.key});

  @override
  Widget build(BuildContext context) {
    // Mengakses provider untuk mendapatkan mata uang yang dipilih
    final discountProvider = Provider.of<DiscountProvider>(context);

    // Mendapatkan formatter mata uang dari provider
    final NumberFormat currencyFormatter = discountProvider.currencyFormatter;
    final NumberFormat currencyFormatterOnline =
        discountProvider.currencyFormatterOnline;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultRow('Final Price:', finalPrice, currencyFormatter),
            _buildCurrencySwitcher(context, discountProvider),
            _buildResultRow('Selling Price:', sellPrice, currencyFormatter),
            if (discountProvider.selectedCurrencyOnline !=
                discountProvider.selectedCurrency)
              _buildResultRow(
                  'Final Price (After Exchange):',
                  discountProvider.finalPriceAfterExchange ?? finalPrice,
                  currencyFormatterOnline),
            if (discountProvider.selectedCurrencyOnline !=
                discountProvider.selectedCurrency)
              _buildResultRow(
                  'Selling Price (After Exchange):',
                  discountProvider.sellPriceAfterExchange ?? sellPrice,
                  currencyFormatterOnline),
          ],
        ),
      ),
    );
  }

  // Membuat baris untuk menampilkan label dan nilai dengan format mata uang
  Widget _buildResultRow(
      String label, double value, NumberFormat currencyFormatter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Gunakan Expanded agar label tidak mempengaruhi teks sebelah kanan
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
              overflow: TextOverflow
                  .ellipsis, // Menambahkan ellipsis jika teks terlalu panjang
            ),
          ),
          Text(
            currencyFormatter.format(value),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Membuat widget untuk tombol tukar mata uang
  Widget _buildCurrencySwitcher(
      BuildContext context, DiscountProvider discountProvider) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(thickness: 1.0),
        Center(
          child: InkWell(
            onTap: () async => _showCurrencyDialog(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
                color: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gunakan Column untuk membiarkan teks overflow ke bawah
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          discountProvider.getFlagByCurrency(
                              discountProvider.selectedCurrencyOnline),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow
                              .visible, // Membiarkan teks overflow ke bawah
                          maxLines: null, // Membiarkan teks memanjang ke bawah
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.change_circle, color: Colors.black),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Menampilkan dialog untuk memilih mata uang
  Future<void> _showCurrencyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Currency'),
          content: Consumer<DiscountProvider>(
            builder: (context, discountProvider, child) => Column(
              mainAxisSize: MainAxisSize.min,
              children: discountProvider.currencies.map((entry) {
                return ListTile(
                  title: Text("${entry['flag']} ${entry['currency']}"),
                  onTap: () {
                    discountProvider.updateCurrencyOnline(entry['currency']!);

                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
