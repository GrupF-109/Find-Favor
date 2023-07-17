import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled/FindFavor/Maps_Page.dart';
import 'Register_Page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  void _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      if (_googleSignIn.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MapsView(
                    userName: '',
                    registeredUsers: [],
                  )),
        );
      }
    } catch (error) {
      print('Google Sign-In Error: ${error.toString()}');
    }
  }

  void _login(BuildContext context) {
    String email = emailController.text;
    String password = passwordController.text;

    bool isUserFound = false;
    String? userName = '';

    for (var user in registeredUsers) {
      if (user['email'] == email && user['password'] == password) {
        isUserFound = true;
        userName = user['name'];
        break;
      }
    }

    if (isUserFound) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MapsView(
              userName: userName,
              registeredUsers: const [],
            ),
          ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Hata'),
                content:
                    const Text('Kullanıcı E-posta adresi veya Şifre hatalı!'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tamam'))
                ],
              ));
    }
  }

  void _goToRegisterPage(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFFFA500),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: height * .25,
                  width: 425,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/topimage.png')),
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
                        const Text('Merhaba, Hoşgeldin...',
                            style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Kullanıcı Adı veya E-posta',
                            prefixIcon: Icon(Icons.account_circle_outlined))),
                    const SizedBox(height: 15),
                    TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Şifre',
                            prefixIcon: Icon(Icons.lock))),
                    customSizedBox(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () => _login(context),
                              child: Container(
                                width: 125,
                                height: 40,
                                decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: const Center(
                                  child: Text(
                                    "Giriş Yap",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            TextButton(
                              onPressed: () => _goToRegisterPage(context),
                              child: Container(
                                width: 125,
                                height: 40,
                                decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: const Center(
                                  child: Text(
                                    'Hesap Olustur',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => _handleSignIn(),
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/googleSign.png')),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Text('Kayıt olmadan devam etmek için tıklayın'),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapsView(
                                    userName: '',
                                    registeredUsers: registeredUsers),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 250),
                            child: Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/withoutlogin.png')))),
                          ),
                        ),
                        Text('')
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customSizedBox() => const SizedBox(
        height: 40,
      );

  InputDecoration customInputDecoration(String hinText) {
    return InputDecoration(
      hintText: hinText,
      hintStyle: const TextStyle(color: Colors.white),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(),
          borderRadius: BorderRadius.all(Radius.circular(4)),
          gapPadding: 4),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }
}
