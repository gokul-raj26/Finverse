import 'package:finverse/models/debt_model.dart';
import 'package:finverse/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DebtProvider extends ChangeNotifier {
  final List<DebtModel> _debts = [];
  List<DebtModel> get debts => List.unmodifiable(_debts);

  Future<void> loadDebts() async {
    final list = await DBService.instance.getAllDebts();
    _debts
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  Future<void> addDebt(DebtModel d) async {
    d.startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final id = await DBService.instance.insertDebt(d);
    d.id = id;
    _debts.insert(0, d);
    notifyListeners();
  }

  Future<void> updateDebt(DebtModel d) async {
    if (d.id == null) return;
    await DBService.instance.updateDebt(d);
    final i = _debts.indexWhere((x) => x.id == d.id);
    if (i >= 0) {
      _debts[i] = d;
      notifyListeners();
    }
  }

  Future<void> deleteDebt(int id) async {
    await DBService.instance.deleteDebt(id);
    _debts.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  double get totalDebts {
    double total = 0;
    for (var d in _debts) {
      total += d.principal;
    }
    return total;
  }

  double get totalMonthlyEmi {
    double sum = 0;
    for (var d in _debts) {
      sum += d.emi;
    }
    return sum;
  }
}
