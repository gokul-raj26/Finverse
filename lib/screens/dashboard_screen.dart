import 'package:finverse/providers/asset_provider.dart';
import 'package:finverse/providers/debt_provider.dart';
import 'package:finverse/screens/add_asset_screen.dart';
import 'package:finverse/screens/debt_screen.dart';
import 'package:finverse/screens/asset_view_screen.dart';
import 'package:finverse/widgets/asset_card.dart';
import 'package:finverse/widgets/networth_card.dart';
import 'package:finverse/widgets/pie_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/';
  const DashboardScreen({Key? key}) : super(key: key);

  String _rupee(double v) {
    final f = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return f.format(v);
  }

  @override
  Widget build(BuildContext context) {
    final assetProv = Provider.of<AssetProvider>(context);
    final debtProv = Provider.of<DebtProvider>(context);

    double totalAssets = assetProv.totalAssetsValue;
    double totalDebts = debtProv.totalDebts;
    double netWorth = totalAssets - totalDebts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finverse'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            onPressed: () {
              Navigator.pushNamed(context, DebtScreen.routeName);
            },
            tooltip: 'Debts & EMIs',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, AddAssetScreen.routeName),
        tooltip: 'Add Asset',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await assetProv.loadAssets();
          await debtProv.loadDebts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworthCard(
                totalAssets: totalAssets,
                totalDebts: totalDebts,
                netWorth: netWorth,
              ),
              const SizedBox(height: 16),
              Text(
                'Asset Distribution',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 220,
                child: assetProv.assets.isEmpty
                    ? const Center(child: Text('No assets yet'))
                    : PieChartWidget(dataMap: assetProv.distributionByType),
              ),
              const SizedBox(height: 16),
              Text(
                'Your Assets',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (assetProv.assets.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('You have no assets. Tap + to add one.')),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: assetProv.assets.length,
                  itemBuilder: (ctx, i) {
                    final asset = assetProv.assets[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AssetViewScreen.routeName,
                          arguments: {'id': asset.id},
                        );
                      },
                      child: AssetCard(
                        asset: asset,
                        onDelete: () async {
                          await assetProv.deleteAsset(asset.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Asset deleted')),
                          );
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
