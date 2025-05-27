class User {
  final String id;
  final String name;
  final double cdStall;
  final String dsStall;
  final String email;
  // final String photoBase64;

  User({
    required this.id,
    required this.name,
    required this.cdStall,
    required this.dsStall,
    required this.email,
    // required this.photoBase64,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      cdStall: (json['cd_stall'] != null)
        ? double.tryParse(json['cd_stall'].toString()) ?? 0.0
        : 0.0,
      dsStall: json['ds_stall'] ?? '',
      email: json['email'] ?? '',
      // photoBase64: json['PHOTO'] ?? '',
    );
  }
}