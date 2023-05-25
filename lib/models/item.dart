class Item {
  final String type;
  final String? name;
  final String id;

  const Item({required this.type, required this.id, this.name});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      type: json['Type'],
      id: json['Id'],
      name: json['Name'],
    );
  }
}
