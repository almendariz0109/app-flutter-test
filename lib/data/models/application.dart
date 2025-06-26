class Application {
  final String nameApp;
  final String description;
  final String? icon;

  Application({
    required this.nameApp,
    required this.description,
    this.icon,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      nameApp: json['nameApp'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nameApp': nameApp,
      'description': description,
      'icon': icon,
    };
  }
}
