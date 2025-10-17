import 'package:finverse/models/asset_model.dart';
import 'package:finverse/providers/asset_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAssetScreen extends StatefulWidget {
  static const routeName = '/add-asset';
  const AddAssetScreen({Key? key}) : super(key: key);

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _type = 'Cash';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _valueCtrl.dispose();
    _quantityCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final asset = AssetModel(
      name: _nameCtrl.text.trim(),
      type: _type,
      value: double.tryParse(_valueCtrl.text.trim()) ?? 0,
      quantity: double.tryParse(_quantityCtrl.text.trim()) ?? 0,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      createdAt: DateTime.now().toIso8601String(),
    );
    await Provider.of<AssetProvider>(context, listen: false).addAsset(asset);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Asset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Asset name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'Stock', child: Text('Stock')),
                  DropdownMenuItem(value: 'Gold', child: Text('Gold')),
                  DropdownMenuItem(value: 'Land', child: Text('Land')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'Cash'),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _valueCtrl,
                decoration: const InputDecoration(labelText: 'Value (₹)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter current value' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantityCtrl,
                decoration: const InputDecoration(labelText: 'Quantity (optional)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save Asset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
