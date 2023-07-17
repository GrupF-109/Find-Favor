import 'package:flutter/material.dart';
import 'login.dart';

class DrawerWidget extends StatelessWidget {
  final List<Map<String, String>> registeredUsers;

  DrawerWidget({
    super.key,
    required this.registeredUsers,
  });

  @override
  Widget build(BuildContext context) {
    var name = 'Misafir';
    var email = '';

    // Check if there are registered users and set the name and email accordingly
    if (registeredUsers.isNotEmpty) {
      name = registeredUsers[0]['name'] ?? '';
      email = registeredUsers[0]['email'] ?? '';
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 64,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Çıkış Yap'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: const Center(
        child: Text('Ayarlar sayfası içeriği burada olacak'),
      ),
    );
  }
}
