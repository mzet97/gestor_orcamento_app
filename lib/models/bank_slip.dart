class BankSlip {
  int? id;
  String? name;
  String? date;
  double? value;

  BankSlip.empty(){
    id = 0;
  }

  BankSlip(
      {this.id = 0,
      required this.name,
      required this.date,
      required this.value});

  BankSlip.formMap(Map<String, dynamic> map) {
    id = int.parse(map['id']);
    name = map['name'];
    date = map['date'];
    value = map['value'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      name!: name!,
      date!: date!,
      'value': value,
    };
    map['id'] = id;
    return map;
  }

  @override
  String toString() {
    return "BankSlip(id: $id, name: $name, date:$date, $value:value)";
  }
}
