import 'package:discount_and_currency_calculator/components/result_card.dart';
import 'package:discount_and_currency_calculator/components/title_widget.dart';
import 'package:discount_and_currency_calculator/pages/history_page.dart';
import 'package:discount_and_currency_calculator/providers/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/discount_provider.dart';

class DiscountCalculatorPage extends StatelessWidget {
  const DiscountCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final discountProvider = Provider.of<DiscountProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discount Calculator'),
        backgroundColor: Colors.white,
        actions: [
          DropdownButton<String>(
            value: discountProvider.selectedCurrency,
            items: discountProvider.currencies.map((currency) {
              return DropdownMenuItem<String>(
                value: currency['currency'],
                child: Row(
                  children: [
                    // Menampilkan bendera dengan ukuran yang konsisten
                    Text(
                      "${currency['flag']} ",
                      style: const TextStyle(
                        fontSize: 20, // Ukuran font lebih besar untuk bendera
                      ),
                    ),
                    // Menampilkan kode mata uang dengan styling
                    Text(
                      currency['currency']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w500, // Memberikan ketebalan pada font
                        color: Colors.black87, // Warna teks agar terlihat jelas
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                discountProvider.updateCurrency(value);
              }
            },
            style: const TextStyle(
                color: Colors.black87), // Warna teks untuk tombol dropdown
            iconEnabledColor: Colors.indigo, // Warna ikon dropdown ketika aktif
            iconDisabledColor:
                Colors.grey, // Warna ikon dropdown ketika tidak aktif
            dropdownColor: Colors.white, // Latar belakang dropdown
            underline: Container(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TitleWidget(title: 'Original Price'),
            const OriginalPriceWidget(),
            const SizedBox(height: 20),
            const TitleWidget(title: 'Discounts'),
            const DiscountListWidget(),
            const SizedBox(height: 20),
            const AddDiscountButtonWidget(),
            const SizedBox(height: 20),
            const TitleWidget(title: 'Desired Profit'),
            const ProfitPriceWidget(),
            const SizedBox(height: 20),
            const CalculateButtonWidget(),
            if (discountProvider.finalPrice != null &&
                discountProvider.sellPrice != null)
              ResultCard(
                finalPrice: discountProvider.finalPrice!,
                sellPrice: discountProvider.sellPrice!,
              ),
          ],
        ),
      ),
    );
  }
}

class CalculateButtonWidget extends StatelessWidget {
  const CalculateButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Provider.of<DiscountProvider>(context, listen: false)
            .calculateFinalPrice();
        
      },
      icon: const Icon(Icons.calculate, color: Colors.white),
      label: const Text(
        'Calculate',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }
}

class ProfitPriceWidget extends StatelessWidget {
  const ProfitPriceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscountProvider>(
      builder: (context, discountProvider, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          controller: discountProvider.profitController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: discountProvider.formatProfit,
          decoration: InputDecoration(
            hintText: 'Enter profit amount',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            prefixIcon: const Icon(Icons.money, color: Colors.indigo),
            contentPadding: const EdgeInsets.all(15.0),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

class AddDiscountButtonWidget extends StatelessWidget {
  const AddDiscountButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Provider.of<DiscountProvider>(context, listen: false)
            .addDiscountField();
      },
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Add Discount',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }
}

class DiscountListWidget extends StatelessWidget {
  const DiscountListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscountProvider>(
      builder: (context, discountProvider, child) => ListView.builder(
        shrinkWrap: true,
        itemCount: discountProvider.discountControllers.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: discountProvider.discountControllers[index],
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Enter discount percentage',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    suffixIcon: const Icon(Icons.percent, color: Colors.indigo),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => discountProvider.removeDiscountField(index),
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OriginalPriceWidget extends StatelessWidget {
  const OriginalPriceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Consumer<DiscountProvider>(
        builder: (context, discountProvider, child) => TextField(
          controller: discountProvider.originalPriceController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: discountProvider.formatOriginalPrice,
          decoration: InputDecoration(
            hintText: 'Enter original price',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            prefixIcon: const Icon(Icons.money, color: Colors.indigo),
            contentPadding: const EdgeInsets.all(15.0),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
