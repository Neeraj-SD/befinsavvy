import 'package:befinsavvy/providers/auth_provider.dart';
import 'package:befinsavvy/providers/income_expense_provider.dart';
import 'package:befinsavvy/providers/task_provider.dart';
import 'package:befinsavvy/screens/auth_screen.dart';
import 'package:befinsavvy/screens/income_expense_screen.dart';
import 'package:befinsavvy/screens/tab1_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => TaskProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => IncomeExpenseProvider(),
          ),
        ],
        child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return HomePageFoo();
              }
              return const AuthScreen();
            }),
      ),
    );
  }
}

class HomePageFoo extends StatefulWidget {
  const HomePageFoo({Key? key}) : super(key: key);

  @override
  State<HomePageFoo> createState() => _HomePageFooState();
}

class _HomePageFooState extends State<HomePageFoo> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    const Tab1(),
    IncomeExpenseScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: (ind) => _onItemTapped(ind),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.task_alt_outlined),
            title: const Text('Taks'),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.monetization_on),
            title: const Text('Insights'),
            // icon: FaIcon(FontAwesomeIcons.solidComments),
            // icon: ,
          ),
        ],
      ),
    );
  }
}
