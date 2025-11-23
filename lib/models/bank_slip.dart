class BankSlip {
  int? id;
  String? name;
  String? date;
  double? value;
  int? categoryId;
  String? description;
  String? tags;
  bool? isPaid;

  BankSlip.empty(){
    id = 0;
    categoryId = 0;
    description = '';
    tags = '';
    isPaid = false;
  }

  BankSlip(
      {this.id = 0,
      required this.name,
      required this.date,
      required this.value,
      this.categoryId = 0,
      this.description = '',
      this.tags = '',
      this.isPaid = false});

  BankSlip.formMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    date = map['date'];
    value = map['value'];
    categoryId = map['categoryId'] ?? 0;
    description = map['description'] ?? '';
    tags = map['tags'] ?? '';
    isPaid = (map['isPaid'] ?? map['is_paid']) ?? false;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'date': date,
      'value': value,
      'categoryId': categoryId,
      'description': description,
      'tags': tags,
      'isPaid': isPaid,
    };
    map['id'] = id;
    return map;
  }

  @override
  String toString() {
    return "BankSlip(id: $id, name: $name, date:$date, value:$value, isPaid:$isPaid)";
  }
}
