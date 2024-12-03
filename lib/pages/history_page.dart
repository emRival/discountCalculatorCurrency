import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            onPressed: () async {
              await historyProvider.clearAllHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All history cleared')),
              );
            },
          ),
        ],
      ),
      body: historyProvider.historyList.isEmpty
          ? const Center(
              child: Text(
                'No history available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: historyProvider.historyList.length,
              itemBuilder: (context, index) {
                final history = historyProvider.historyList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      history.date,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Original Price: ${history.originalPrice}'),
                        Text('Discounts: ${history.discount}'),
                        Text('Final Price: ${history.finalPrice}'),
                        Text('Profit: ${history.profit}'),
                        Text('Sell Price: ${history.sellPrice}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await historyProvider.deleteHistory(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('History deleted')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
