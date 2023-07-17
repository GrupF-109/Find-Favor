import 'package:flutter/material.dart';
import 'package:untitled/FindFavor/drawer_widget.dart';
import 'Maps_Page.dart';
import 'Register_Page.dart';

class Ayarlar extends StatefulWidget {
  const Ayarlar({super.key});

  @override
  State<Ayarlar> createState() => _AyarlarState();
}

int _currentIndex = 1;

class _AyarlarState extends State<Ayarlar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFA500),
      endDrawer: DrawerWidget(registeredUsers: registeredUsers),
      appBar: AppBar(
        title: const Text('Merhaba'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.chevron_left_outlined,
            color: Color.fromARGB(255, 70, 70, 69),
          ),
        ),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(
                Icons.person,
                color: Color.fromARGB(255, 70, 70, 69),
              ),
            );
          }),
        ],
      ),
      body: const Column(
        children: [
          Padding(
            padding: ProjectPadding.pagePaddingAll,
            child: ilanlar_sizedBox(
              ilan: '',
              sizedBoxColor: Colors.blue,
            ),
          ),
          Padding(
            padding: ProjectPadding.pagePaddingAll,
            child: ilanlar_sizedBox(
              ilan: '',
              sizedBoxColor: Colors.blue,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedFontSize: 15,
        unselectedFontSize: 12,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: HomePageIconButton(),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: SettingPageIconButton(),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}

class ilanlar_sizedBox extends StatelessWidget {
  const ilanlar_sizedBox({
    super.key,
    required this.ilan,
    this.sizedBoxColor = Colors.orangeAccent,
  });

  final String ilan;
  final sizedBoxColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 90,
        width: 400,
        child: Container(
          decoration: BoxDecoration(
              color: sizedBoxColor, borderRadius: BorderRadius.circular(15)),
          child: ElevatedButton(
              onPressed: () {},
              child: Text(
                (ilan),
                textAlign: TextAlign.center,
              )),
        ));
  }
}
