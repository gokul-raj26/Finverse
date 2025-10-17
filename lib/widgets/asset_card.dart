
import 'package:finverse/models/asset_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssetCard extends StatelessWidget {
  final AssetModel asset;
  final VoidCallback? onDelete;
  const AssetCard({Key? key, required this.asset, this.onDelete}) : super(key: key);

  String _rupee(double v) => NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(v);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(asset.type[0]),
        ),
        title: Text(asset.name),
        subtitle: Text('${asset.type} • ${asset.quantity > 0 ? 'Qty ${asset.quantity} • ' : ''}Added: ${asset.createdAt.split(' ').first}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_rupee(asset.value)),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
