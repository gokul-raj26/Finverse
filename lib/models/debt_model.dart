class DebtModel {
  int? id;
  String name;
  double principal;
  double emi;
  double interestRate; // annual %
  String startDate;
  String? endDate;
  String? notes;

  DebtModel({
    this.id,
    required this.name,
    required this.principal,
    required this.emi,
    required this.interestRate,
    required this.startDate,
    this.endDate,
    this.notes,
  });

  factory DebtModel.fromMap(Map<String, dynamic> m) => DebtModel(
        id: m['id'] as int?,
        name: m['name'] as String,
        principal: (m['principal'] as num).toDouble(),
        emi: (m['emi'] as num).toDouble(),
        interestRate: (m['interestRate'] as num).toDouble(),
        startDate: m['startDate'] as String,
        endDate: m['endDate'] as String?,
        notes: m['notes'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'principal': principal,
        'emi': emi,
        'interestRate': interestRate,
        'startDate': startDate,
        'endDate': endDate,
        'notes': notes,
      };
}
