import 'package:finverse/models/debt_model.dart';
import 'package:finverse/providers/debt_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DebtScreen extends StatefulWidget {
  static const routeName = '/debts';
  const DebtScreen({Key? key}) : super(key: key);

  @override
  State<DebtScreen> createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _principalCtrl = TextEditingController();
  final _emiCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _principalCtrl.dispose();
    _emiCtrl.dispose();
    _rateCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _addDebt() async {
    if (!_formKey.currentState!.validate()) return;
    final debt = DebtModel(
      name: _nameCtrl.text.trim(),
      principal: double.tryParse(_principalCtrl.text.trim()) ?? 0,
      emi: double.tryParse(_emiCtrl.text.trim()) ?? 0,
      interestRate: double.tryParse(_rateCtrl.text.trim()) ?? 0,
      startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );
    await Provider.of<DebtProvider>(context, listen: false).addDebt(debt);
    _nameCtrl.clear();
    _principalCtrl.clear();
    _emiCtrl.clear();
    _rateCtrl.clear();
    _notesCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final debtProv = Provider.of<DebtProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts & EMIs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text('Total debt: ₹${debtProv.totalDebts.toStringAsFixed(2)}'),
                    const SizedBox(height: 6),
                    Text('Monthly EMI total: ₹${debtProv.totalMonthlyEmi.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: debtProv.debts.isEmpty
                  ? const Center(child: Text('No debts recorded'))
                  : ListView.builder(
                      itemCount: debtProv.debts.length,
                      itemBuilder: (ctx, i) {
                        final d = debtProv.debts[i];
                        return Dismissible(
                          key: ValueKey(d.id),
                          background: Container(color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
                          onDismissed: (_) {
                            debtProv.deleteDebt(d.id!);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debt deleted')));
                          },
                          child: ListTile(
                            title: Text(d.name),
                            subtitle: Text('Principal: ₹${d.principal.toStringAsFixed(2)} • EMI: ₹${d.emi.toStringAsFixed(2)}'),
                            trailing: Text(d.startDate),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            ExpansionTile(
              title: const Text('Add Debt / EMI'),
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(labelText: 'Loan name / Bank'),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _principalCtrl,
                          decoration: const InputDecoration(labelText: 'Principal (₹)'),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter principal' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emiCtrl,
                          decoration: const InputDecoration(labelText: 'Monthly EMI (₹)'),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter EMI' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _rateCtrl,
                          decoration: const InputDecoration(labelText: 'Interest rate (annual %)'),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _notesCtrl,
                          decoration: const InputDecoration(labelText: 'Notes (optional)'),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: _addDebt, child: const Text('Save Debt')),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
