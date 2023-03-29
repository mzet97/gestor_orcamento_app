class BankSlip {
  int? id;
  String? name;
  String? date;
  double? value;

  BankSlip.empty();

  BankSlip(
      {this.id = 0,
      required this.name,
      required this.date,
      required this.value});

  BankSlip.formMap(Map map) {
    id = map['id'];
    name = map['name'];
    date = map['date'];
    value = map['value'];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      name!: name!,
      date!: date!,
      'value': value,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "BankSlip(id: $id, name: $name, date:$date, $value:value)";
  }
}
