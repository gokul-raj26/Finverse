import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NetworthCard extends StatelessWidget {
  final double totalAssets;
  final double totalDebts;
  final double netWorth;
  const NetworthCard({
    Key? key,
    required this.totalAssets,
    required this.totalDebts,
    required this.netWorth,
  }) : super(key: key);

  String _rupee(double v) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(v);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final positive = netWorth >= 0;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Net Worth', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    _rupee(netWorth),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: positive ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Assets', style: theme.textTheme.bodySmall),
                          Text(
                            _rupee(totalAssets),
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Debts', style: theme.textTheme.bodySmall),
                          Text(
                            _rupee(totalDebts),
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: Icon(
                Icons.account_balance_wallet,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
