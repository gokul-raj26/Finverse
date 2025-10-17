import 'package:finverse/models/asset_model.dart';
import 'package:finverse/providers/asset_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AssetViewScreen extends StatelessWidget {
  static const routeName = '/asset-view';
  final int assetId;
  const AssetViewScreen({Key? key, required this.assetId}) : super(key: key);

  String _rupee(double v) => NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(v);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetProvider>(context);
    final asset = provider.assets.firstWhere((a) => a.id == assetId, orElse: () => AssetModel(name: 'Unknown', type: 'Unknown', value: 0, createdAt: DateTime.now().toIso8601String()));
    return Scaffold(
      appBar: AppBar(title: Text(asset.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(asset.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(asset.type)),
                const SizedBox(width: 12),
                Text(_rupee(asset.value), style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 12),
            if (asset.quantity > 0) Text('Quantity: ${asset.quantity}'),
            const SizedBox(height: 8),
            if (asset.notes != null) Text('Notes: ${asset.notes}'),
            const SizedBox(height: 8),
            Text('Added: ${asset.createdAt}'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                if (asset.id == null) return;
                await provider.deleteAsset(asset.id!);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete Asset'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            )
          ],
        ),
      ),
    );
  }
}
