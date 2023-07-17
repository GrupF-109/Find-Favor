import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Setting_Page.dart';
import 'drawer_widget.dart';

class MapsView extends StatefulWidget {
  final String? userName;
  final List<Map<String, String>> registeredUsers;
  const MapsView({
    Key? key,
    required this.userName,
    required this.registeredUsers,
  }) : super(key: key);

  @override
  State<MapsView> createState() => _MapsViewState();
}

Position? _currentPosition;

class _MapsViewState extends State<MapsView> {
  late GoogleMapController? _mapController;

  final istanbul = const LatLng(41.005722329812656, 28.965476796981466);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
        _getCurrentLocation();
      });
    } else if (permissionStatus.isDenied) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Konum İzni Reddedildi'),
          content: const Text(
              'Konum izni verilmedi. Uygulamayı kullanmak için konum iznine ihtiyacımız var.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
              child: const Text('Ayarlara Git'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  void _goToCurrentLocation() {
    if (_currentPosition != null) {
      var currentLocation = LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation,
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFA500),
      endDrawer: DrawerWidget(
        registeredUsers: [],
      ),
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
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
      body: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (controller) async {
          _mapController = controller;
          await _createMarkerImageFromAsset();
        },
        initialCameraPosition: CameraPosition(target: istanbul, zoom: 11),
        markers: _createMarker(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCurrentLocation,
        icon: const Icon(Icons.location_on),
        label: const Text('Konumumu Bul'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
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

  BitmapDescriptor navigation = BitmapDescriptor.defaultMarker;
  BitmapDescriptor jopsearching = BitmapDescriptor.defaultMarker;

  Future<void> _createMarkerImageFromAsset() async {
    final ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context);
    final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      imageConfiguration,
      'assets/images/jopsearching.png',
    );
    var bitmap = await BitmapDescriptor.fromAssetImage(
      imageConfiguration,
      'assets/images/navigation.png',
    );
    setState(() {
      navigation = bitmap;
      jopsearching = customIcon;
    });
  }

  Set<Marker> _createMarker() {
    final markers = <Marker>{};

    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('hgkgltfhdf'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          icon: navigation,
        ),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('fgmfgöhghösdf'),
          position: const LatLng(41.009088292150636, 28.978491523147518),
          icon: jopsearching,
          infoWindow: InfoWindow(
            title: 'merhaba',
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Marker a tıklandı'),
                    content:
                        const Text('Bu, Marker a tıklandığında açılan sayfa'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('kapat'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      );
      markers.add(Marker(
        markerId: const MarkerId('fgkgöhjfghj'),
        position: const LatLng(41.01685649153084, 28.947045152517923),
        icon: jopsearching,
        infoWindow: InfoWindow(
          title: 'Yahya Kemal Müzesine Gönüllü Arıyoruz',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.orange,
                  title: const Text(
                    'Yahya Kemal Müzesine Gönüllü Arıyoruz',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2),
                  ),
                  content: Text(
                    ilanMetinleri().yahyakemalmuzesi,
                  ),
                  scrollable: true,
                  contentTextStyle: Theme.of(context).textTheme.bodyLarge,
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('kapat'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ));
      markers.add(Marker(
        markerId: const MarkerId('ghmgöhjç'),
        position: const LatLng(38.75683526555869, 30.53860133757449),
        icon: jopsearching,
        infoWindow: InfoWindow(
          title: 'Köy Okulu Ziyareti',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.orange,
                  title: const Text(
                    'Köy Okulu Ziyareti',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2),
                  ),
                  content: Text(
                    ilanMetinleri().afyonkoyokulu,
                  ),
                  scrollable: true,
                  contentTextStyle: Theme.of(context).textTheme.bodyLarge,
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('kapat'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ));
      markers.add(Marker(
        markerId: const MarkerId('mbnmdfgsd'),
        position: const LatLng(41.1423428011483, 28.457654325909775),
        icon: jopsearching,
        infoWindow: InfoWindow(
          title: 'Gönüllü Drama Eğitmeni',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.orange,
                  title: const Text(
                    'Gönüllü Drama Eğitmeni',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2),
                  ),
                  content: Text(
                    ilanMetinleri().catalcadrama,
                  ),
                  scrollable: true,
                  contentTextStyle: Theme.of(context).textTheme.bodyLarge,
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('kapat'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ));
      markers.add(Marker(
        markerId: const MarkerId('sfshdfjhf'),
        position: const LatLng(38.1582237392272, 27.365219414669568),
        icon: jopsearching,
        infoWindow: InfoWindow(
          title: 'Metropolis Antik Kenti 2023 Yılı Kazı Çalışmaları',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.orange,
                  title: const Text(
                    'Metropolis Antik Kenti 2023 Yılı Kazı Çalışmaları',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2),
                  ),
                  content: Text(
                    ilanMetinleri().izmirantik,
                  ),
                  scrollable: true,
                  contentTextStyle: Theme.of(context).textTheme.bodyLarge,
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('kapat'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ));
      markers.add(Marker(
        markerId: const MarkerId('sdadfgsfdhjsfa'),
        position: const LatLng(41.1423428011483, 28.457654325909775),
        icon: jopsearching,
        infoWindow: InfoWindow(
          title: 'Priene Kazısı ',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.orange,
                  title: const Text(
                    'Priene Kazısı ',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2),
                  ),
                  content: Text(
                    ilanMetinleri().aydinpirene,
                  ),
                  scrollable: true,
                  contentTextStyle: Theme.of(context).textTheme.bodyLarge,
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('kapat'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ));
      markers.add(Marker(
        markerId: const MarkerId('sdasghjfgghjffa'),
        position: const LatLng(41.14092250353436, 28.46785252089287),
        icon: jopsearching,
        infoWindow: InfoWindow(
          title: 'Gönüllü İngilizce Eğitmeni Aranıyor!',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.orange,
                  title: const Text(
                    'Gönüllü İngilizce Eğitmeni Aranıyor!',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2),
                  ),
                  content: Text(
                    ilanMetinleri().catalcaingilizce,
                  ),
                  scrollable: true,
                  contentTextStyle: Theme.of(context).textTheme.bodyLarge,
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('kapat'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ));
      markers.add(Marker(
        markerId: const MarkerId('çşglksd'),
        position: const LatLng(41.14977738674048, 28.455922055524233),
        icon: jopsearching,
        infoWindow: InfoWindow(
          title: 'Kuranı Kerim Eğitimi Verecek Gönüllüler Arıyoruz ',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.orange,
                  title: const Text(
                    'Kuranı Kerim Eğitimi Verecek Gönüllüler Arıyoruz ',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2),
                  ),
                  content: Text(
                    ilanMetinleri().catalcakuran,
                  ),
                  scrollable: true,
                  contentTextStyle: Theme.of(context).textTheme.bodyLarge,
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('kapat'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ));
      markers.add(Marker(
        markerId: const MarkerId('sadasdadasd'),
        position: const LatLng(41.08291147087158, 28.81563698927526),
        icon: jopsearching,
        infoWindow: InfoWindow(
          title: 'U17 Dünya Güreş Şampiyonası',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.orange,
                  title: const Text(
                    'U17 Dünya Güreş Şampiyonası',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2),
                  ),
                  content: Text(
                    ilanMetinleri().basaksehirgures,
                  ),
                  scrollable: true,
                  contentTextStyle: Theme.of(context).textTheme.bodyLarge,
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('kapat'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ));
    }
    return markers;
  }
}

class ilanMetinleri {
  String as = '';

  String basaksehirgures =
      '31 Temmuz - 06 Ağustos 2023 tarihleri arasında düzenlenecek olan U17 Dünya Güreş Şampiyonasında görev alacak gönüllülere ihtiyaç duyuyoruz. Tüm zamanını bize ayırabileceksen, dinamik ve takım çalışmasına ayak uydurabileceğini düşünüyorsan seni aramızda görmekten mutluluk duyarız!\nGörevler\nKafilelere eşlik etme\nDelege rehberliği\nAkreditasyon merkezi\nSaha içi yönlendirme\nVIP ve protokole eşlik etme\nMadalya töreninde görev alma\nUlaştırma alanında görev almak\nDinamik ve aktif görevlerin yerine getirilmesi\n\nGönüllülerimizde aradığımız kriterler;\nİyi derecede İngilizce bilen,\nTercihen ikinci dil bilen,\nEsnek çalışma saatlerine uyum sağlayabilen,\nDiksiyonu düzgün olan,\nSpora ilgisi olan,\nTercihen daha önce herhangi bir spor organizasyonu gönüllük projesinde yer almış,\n\nÖnemli Notlar;\nBaşvuruların İstanbulda, tercihen Avrupa Yakasında ikamet eden adaylar tarafında yapılması rica olunur.\nFotoğrafsız ve bilgileri tam olmayan başvurular kabul edilmeyecektir.\nÖn başvurusu kabul edilen adaylara sistem üzerinde bulunan telefon numaraları üzerinden mesaj gönderilecektir.\nBaşvurusu kabul edilmeyen adayların durumları sistemde görünecektir.\nMail ve sosyal medya üzerinden yapılan başvurular kabul edilmeyecektir.\nBaşvurusu onaylanan ve katılacağı kesinleştiği halde hiçbir gerekçe göstermeden programımıza katılmayacak gönüllülerin federasyonumuzca yapılacak olan organizasyonlarımıza başvurusu kabul edilmeyecektir.\nKabul edilen gönüllülerimiz için bilgilendirme amaçlı whatsapp grubu oluşturulacaktır.';

  String izmirantik =
      'T.C. Kültür ve Turizm Bakanlığı, Türk Tarih Kurumu ve Dokuz Eylül Üniversitesi adına yürütülen, İzmir İli Torbalı İlçesinde yer alan Metropolis Antik Kenti, 2023 yılı kazı çalışmaları için siz değerli gönüllülere davet etmektedir.\n\nBaşvuruda bulunacak gönüllülerin: \nArkeoloji, Sanat Tarihi, Antropoloji, Kültürel Miras Yönetimi, müzecilik, Restorasyon ve Konservasyon, Mimarlık bölümlerinden birinde lisans veya lisansüstü eğitim alıyor olması şartı aranmaktadır.\nBaşvurular sadece sistem ve mail üzerinden kabul edilecek olup, telefon ile irtibat kurulmaması rica olunur.\nhttps://metropolistr.org/ sitemizden çalışmalarımız ile ilgili bilgi edinebilir, info@metropolistr.org adresinden bizlere ulaşabilirsiniz.\n\nNot: Konaklama, iaşe ve kazı evinin diğer imkanları Kazı Başkanlığı tarafından sağlanacaktır.\nKazı evi hafta içi (Pazartesi-Cuma) konaklama için uygundur.\nBaşvuruda eğitim ve iletişim bilgilerinizin tam olması gerekmektedir.';

  String aydinpirene =
      'T.C. Kültür ve Turizm Bakanlığı izniyle, Bursa Uludağ Üniversitesi öğretim üyesi Prof. Dr. İbrahim Hakan Mert başkanlığında gerçekleştirilecek olan “Priene Kazısı" projesi kapsamında gönüllü, arkeoloji bölümü lisans öğrencileri aranmaktadır.\nBaşvuru için lütfen CV nizi eklemeyi unutmayınız. \nAşağıdaki zaman dilimleri için başvuru yapabilirsiniz.\n1 Ağustos - 1 Eylül\n1 Eylül - 30 Eylül\n\nLütfen gönüllü olarak katılmak istediğiniz zaman dilimini başvurunuza ekleyiniz. Eğer kalmak istediğiniz tarihler bunlardan farklıysa da bunu ayrıca belirtebilirsiniz.\nGönüllülerin ulaşım masrafı maalesef karşılanmamaktadır.\nGönüllülerin konaklaması kazı evinde sağlanacaktır.\nGönüllülerin yeme-içmesi kazı evinde sağlanacaktır.\n\nÖnemli: \n\nCV nizi lütfen mail olarak aşağıdaki mail adresine yollayınız.\n\nkuru.bugra@gmail.com';

  String catalcaingilizce =
      'Dil eğitimleri atölyemizde açılacak olan başlangıç seviyesi İngilizce eğitimi için gönüllü İngilizce eğitmenlerine ihtiyaç duymaktayız. Başvuracak gönüllülerimiz 18-29 yaş aralığındaki gençlerimize başlangıç seviyesinde İngilizce eğitimi verecek olup üniversitelerin İngiliz Dili ve Edebiyatı bölümlerinde öğrenci veya mezun olmaları beklenmektedir. \n\nNot:Eğitim saatlerİ katılımcılara göre ayarlanacaktır.';
  String catalcakuran =
      'GENÇLİK MERKEZİNDE İLKOKUL VE ORTAOKUL ÖĞRENCİLERİNE 8 HAFTA BOYUNCA HAFTADA 1 GÜN İKİ SAAT KURAN I KERİM EĞİTİMİ VEREBİLECEK İMAM HATİP LİSESİ MEZUNU, İLAHİYAT FAKÜLTESİ ÖĞRENCİSİ VEYA MEZUNU GÖNÜLLÜ ARKADAŞLAR ARIYORUZ.';
  String catalcadrama =
      'Kişisel Gelişim Atölyemiz kapsamında \n-Tiyatro Kulübümüzde eğitmenlik yapacak, \n-Üniversitelerin ilgili alanlarından mezun ya da halihazırda okuyan, \n-Haftada en az 2 gün 2 şer saat ders verebilecek, \n-Tiyatro drama vs. konularında deneyimli, donanımlı ve gerekli eğitimleri almış, \n-14-25 yaş arası gönüllü gençlere eğitim verebilecek gönüllüler arıyoruz. \n\nBaşvurularınızı bekliyoruz.';
  String afyonkoyokulu =
      'Sultan Divani Yurt Müdürlüğü olarak gönüllü gençlerimizle birlikte köy okulu ziyaretlerinde bulunacağız. \nFaaliyet kapsamında yüz boyama, sokak oyunları, öğrencilere kalem dağıtılması gibi etkinlikler yapılacaktır. \nBu etkinliklerin planlanmasında ve uygulanmasında görev alacak, etkinlikler boyunca fotoğraf ve video çekimi yapabilecek gönüllü gençlerin başvurularını bekliyoruz.';
  String yahyakemalmuzesi =
      'Yahya kemal beyatlı müzesini ziyaretçilere gezdirmek, onlara müzeyle ilgili rehberlik etmek üzere gönüllüler arıyoruz. \nMüzemiz hafta içi  her gün 10.00 - 16.00 Saatleri arasında açıktır. \nHafta içi söz konusu saatler aralığında haftada 1 tam gün müze ziyaretçilerine refakat edebilirsiniz. \n\nGönüllülerimizde aradığımız özellikler:\n\nüniversite öğrencisi ya da mezunu olmak,\ntercihen yabancı dil bilmek,\nmüze ziyaretçilerine refakat etmeyi engelleyecek beden ya da konuşma engeli bulunmamak,\nhafta içi 1 tam gün gönüllü olarak çalışaya zaman ayrıabilecek durumda olmak.\n\nGönüllü başvurusunda bulunan adaylarla ön görüşme yaparak uygunluklarını değerlendiriyoruz.';
}

class ProjectPadding {
  static const pagePaddingAll = EdgeInsets.all(3.0);
}

class SettingPageIconButton extends StatelessWidget {
  const SettingPageIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Ayarlar(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      icon: const Icon(Icons.settings),
    );
  }
}

class HomePageIconButton extends StatelessWidget {
  const HomePageIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MapsView(
              userName: '',
              registeredUsers: [],
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      icon: const Icon(Icons.home_max_outlined),
    );
  }
}
