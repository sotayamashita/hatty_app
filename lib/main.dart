import 'dart:convert';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';

final Uri _faqUrl = Uri.parse('https://autify.com/news/hi-hatty');
final Uri _codeUrl = Uri.parse('https://github.com/sotayamashita/hatty_app');

class Hatty {
  final String url;

  const Hatty({
    required this.url,
  });

  factory Hatty.fromJson(Map<String, dynamic> json) {
    return Hatty(url: json['url']);
  }
}

void main() {
  if (!kIsWeb) {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Hatty Hive'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Hatty> _hattyList = [];
  void _initHattyData() async {
    final response = await http
        .get(Uri.parse("https://sotayamashita.github.io/hatty_api/index.json"));
    if (response.statusCode == 200) {
      final List<dynamic> hattyList = jsonDecode(response.body);
      setState(() {
        _hattyList = hattyList.map((hatty) => Hatty.fromJson(hatty)).toList();
        _hattyList.shuffle();
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load hatty data');
    }
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _initHattyData();
    if (!kIsWeb) {
      FlutterNativeSplash.remove();
    }
  }

  void _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle textStyle = theme.textTheme.bodyText2!;
    final List<Widget> aboutBoxChildren = <Widget>[
      const SizedBox(height: 24),
      RichText(
          text: TextSpan(children: <TextSpan>[
        TextSpan(
          style: textStyle,
          text: "hogehoge",
        )
      ]))
    ];

    return Scaffold(
        // TODO: Externalize
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.hive),
                title: const Text("Hive"),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                  leading: const Icon(Icons.question_mark),
                  title: const Text('FAQ'),
                  onTap: () => _launchUrl(_faqUrl)),
              ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Code'),
                  onTap: () => _launchUrl(_codeUrl)),
              AboutListTile(
                icon: const Icon(Icons.info),
                applicationIcon: const FlutterLogo(),
                applicationName: _packageInfo.appName,
                applicationVersion: _packageInfo.version,
                applicationLegalese: '\u{a9} 2021 <TBD>',
                aboutBoxChildren: aboutBoxChildren,
              )
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title, style: GoogleFonts.roboto()),
        ),
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: _hattyList.length,
            itemBuilder: (BuildContext context, int index) =>
                Image.network(_hattyList[index].url)));
  }
}
