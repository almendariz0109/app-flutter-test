import 'application.dart';

class User {
  final String id;
  final String name;
  final double cdStall;
  final String dsStall;
  final String email;
  final List<Application> applications;
  // final String photoBase64;

  User({
    required this.id,
    required this.name,
    required this.cdStall,
    required this.dsStall,
    required this.email,
    required this.applications,
    // required this.photoBase64,
  });

  factory User.fromJson(Map<String, dynamic> json) {

    List<Application> apps = [];

    if (json['applications'] != null && json['applications'] is List) {
      apps = (json['applications'] as List)
        .map((item) => Application.fromJson(item))
        .toList();
    }

    return User(
      id: json['id'] ?? json['login'] ?? '',
      name: json['name'] ?? '',
      cdStall: (json['cd_stall'] != null)
        ? double.tryParse(json['cd_stall'].toString()) ?? 0.0
        : 0.0,
      dsStall: json['ds_stall'] ?? '',
      email: json['email'] ?? '',
      applications: apps,
      // photoBase64: json['PHOTO'] ?? '',
    );
  }
}