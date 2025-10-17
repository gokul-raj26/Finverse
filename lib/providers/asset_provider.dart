import 'package:flutter/material.dart';
import 'package:finverse/models/asset_model.dart';
import 'package:finverse/services/db_service.dart';
import 'package:intl/intl.dart';

class AssetProvider extends ChangeNotifier {
  final List<AssetModel> _assets = [];
  List<AssetModel> get assets => List.unmodifiable(_assets);

  Future<void> loadAssets() async {
    final list = await DBService.instance.getAllAssets();
    _assets
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  Future<void> addAsset(AssetModel asset) async {
    asset.createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final id = await DBService.instance.insertAsset(asset);
    asset.id = id;
    _assets.insert(0, asset);
    notifyListeners();
  }

  Future<void> updateAsset(AssetModel asset) async {
    if (asset.id == null) return;
    await DBService.instance.updateAsset(asset);
    final i = _assets.indexWhere((a) => a.id == asset.id);
    if (i >= 0) {
      _assets[i] = asset;
      notifyListeners();
    }
  }

  Future<void> deleteAsset(int id) async {
    await DBService.instance.deleteAsset(id);
    _assets.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  double get totalAssetsValue {
    double total = 0;
    for (var a in _assets) total += a.value;
    return total;
  }

  Map<String, double> get distributionByType {
    final Map<String, double> map = {};
    for (var a in _assets) {
      map[a.type] = (map[a.type] ?? 0) + a.value;
    }
    return map;
  }

  AssetModel? getById(int id) =>
      _assets.firstWhere((a) => a.id == id, orElse: () => null as AssetModel);
}
