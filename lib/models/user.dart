class User {
  final String id;
  final String name;
  final String? imageTag;

  const User({required this.id, required this.name, this.imageTag});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['Id'],
      name: json['Name'],
      imageTag: json['PrimaryImageTag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'Id': id, 'Name': name};
  }
}
