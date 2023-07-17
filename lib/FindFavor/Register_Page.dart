import 'package:flutter/material.dart';

List<Map<String, String>> registeredUsers = [];

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterPage({Key? key});

  Future<void> _createAccount(context) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hata'),
          content: const Text('Lütfen gerekli alanları doldurunuz'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
      return;
    }

    addToRegisteredUsers(name, email, password);

    Navigator.pushReplacementNamed(context, '/login');
  }

  void addToRegisteredUsers(String name, String email, String password) {
    registeredUsers.add({'name': name, 'email': email, 'password': password});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFA500),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 200,
                width: 425,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/topimage.png'),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.only(right: 100),
                  child: Row(
                    children: [
                      Container(
                          width: 90,
                          height: 100,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/appIcon.png')))),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        child: const Text(
                            'Kayıt olmak için\nlütfen gerekli yerleri\ndoldurunuz...',
                            style: TextStyle(fontSize: 17),
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 50),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Adınız',
                      prefixIcon: Icon(Icons.person_add_alt_1_outlined),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-posta',
                      prefixIcon: Icon(Icons.mark_email_read_outlined),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Şifre',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _createAccount(context),
              child: Container(
                width: 150,
                height: 40,
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white)),
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Text(
                    "Kayıt Ol",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
