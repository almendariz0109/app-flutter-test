import 'package:flutter/material.dart';
import '../../../data/models/user.dart';
import '../../../core/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  final String login;

  const ProfilePage({super.key, required this.login});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _userFuture = UserService().fetchUserDetails(widget.login);
  }

  void _loadUser() {
    _userFuture = UserService().fetchUserDetails(widget.login);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _loadUser(); // recarga el perfil al volver de fondo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No se pudo cargar el perfil.'));
          }

          final user = snapshot.data!;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  child: const Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(user.email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text('Puesto: ${user.dsStall}'),
                Text('Usuario: ${user.id}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
