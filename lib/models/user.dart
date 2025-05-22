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
      name: json['NAME'] ?? '',
      cdStall: (json['CD_STALL'] != null)
        ? double.tryParse(json['CD_STALL'].toString()) ?? 0.0
        : 0.0,
      dsStall: json['DS_STALL'] ?? '',
      email: json['EMAIL'] ?? '',
      // photoBase64: json['PHOTO'] ?? '',
    );
  }
}