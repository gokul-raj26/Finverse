class AssetModel {
  int? id;
  String name;
  String type; // e.g., stock, gold, land, cash
  double value; // total current value in currency
  double quantity; // optional (like grams of gold or shares)
  String? notes;
  String createdAt;

  AssetModel({
    this.id,
    required this.name,
    required this.type,
    required this.value,
    this.quantity = 0,
    this.notes,
    required this.createdAt,
  });

  factory AssetModel.fromMap(Map<String, dynamic> m) => AssetModel(
        id: m['id'] as int?,
        name: m['name'] as String,
        type: m['type'] as String,
        value: (m['value'] as num).toDouble(),
        quantity: (m['quantity'] as num).toDouble(),
        notes: m['notes'] as String?,
        createdAt: m['createdAt'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': type,
        'value': value,
        'quantity': quantity,
        'notes': notes,
        'createdAt': createdAt,
      };
}
