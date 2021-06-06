import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lets_talk/models/client.dart';
import 'package:lets_talk/models/contact.dart';
import 'package:lets_talk/models/current_chat_model.dart';
import 'package:lets_talk/screens/chat_screen.dart';
import 'package:lets_talk/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isLinux || Platform.isMacOS || Platform.isWindows)) {
    await DesktopWindow.setMinWindowSize(Size(600, 800));
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => CurrentChatModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Spotify UI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        scaffoldBackgroundColor: const Color(0xFF121212),
        backgroundColor: const Color(0xFF121212),
        primaryColor: Color(0xFF282E33),
        accentColor: const Color(0xFF9D7D2A),
        iconTheme: const IconThemeData().copyWith(color: Colors.grey[500]),
        fontFamily: 'Montserrat',
        inputDecorationTheme: InputDecorationTheme(
            focusColor: const Color(0xFF9D7D2A),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                // ignore: deprecated_member_use
                color: const Color(0xFF9D7D2A),
              ),
            ),
            hintStyle: TextStyle(
              color: Color(0xFF818991),
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            )),
        textTheme: TextTheme(
          headline2: const TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
          headline4: TextStyle(
            fontSize: 12.0,
            color: Colors.grey[300],
            fontWeight: FontWeight.w500,
            letterSpacing: 2.0,
          ),
          bodyText1: TextStyle(
            color: Colors.grey[300],
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          bodyText2: TextStyle(
            color: Colors.grey[300],
            letterSpacing: 1.0,
          ),
        ),
      ),
      home: ChangeNotifierProvider(
        create: (context) => Client(),
        child: ChangeNotifierProvider(
          create: (context) => ContactListModel(),
          child: Login(),
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String name = '';
  String addr = '';

  @override
  Widget build(BuildContext context) {
    final connected = context.watch<Client>().connected;

    return connected
        ? Shell()
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'assets/icon.png',
                          height: 55.0,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        "LAN gist",
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200.0,
                        child: TextField(
                          onChanged: (value) {
                            name = value;
                          },
                          // ignore: deprecated_member_use
                          cursorColor: Theme.of(context).accentColor,
                          decoration: InputDecoration(
                            focusColor: Theme.of(context)
                                .inputDecorationTheme
                                .focusColor,
                            focusedBorder: Theme.of(context)
                                .inputDecorationTheme
                                .focusedBorder,
                            hintText: 'Enter your name',
                            hintStyle: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Container(
                        width: 200.0,
                        child: TextField(
                          onChanged: (value) {
                            addr = value;
                          },
                          // ignore: deprecated_member_use
                          cursorColor: Theme.of(context).accentColor,
                          decoration: InputDecoration(
                            focusColor: Theme.of(context)
                                .inputDecorationTheme
                                .focusColor,
                            focusedBorder: Theme.of(context)
                                .inputDecorationTheme
                                .focusedBorder,
                            hintText: 'Enter server address',
                            hintStyle: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18.0),
                  OutlinedButton(
                    onPressed: () {
                      context.read<Client>().connect(context, name, addr);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Connect',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        !context.read<Client>().connecting
                            ? SizedBox.shrink()
                            : const SizedBox(
                                width: 8.0,
                              ),
                        !context.read<Client>().connecting
                            ? SizedBox.shrink()
                            : SpinKitFadingCircle(
                                // ignore: deprecated_member_use
                                color: Theme.of(context).accentColor,
                                size: 18,
                              ),
                      ],
                    ),
                    style: OutlinedButton.styleFrom(
                      // ignore: deprecated_member_use
                      //backgroundColor: Theme.of(context).accentColor,
                      side: BorderSide(
                          width: 0.5,
                          // ignore: deprecated_member_use
                          color: Theme.of(context).accentColor),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 60.0,
                    width: MediaQuery.of(context).size.width,
                    color: context.read<Client>().errorMessage == null
                        ? Colors.transparent
                        : Colors.red[800],
                    child: context.read<Client>().errorMessage == null
                        ? null
                        : Center(
                            child: Text(
                              context.read<Client>().errorMessage ?? '',
                              style: Theme.of(context).textTheme.bodyText2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
  }
}

class Shell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 800) SideBar(),
          ChatScreen(),
        ],
      ),
    );
  }
}
