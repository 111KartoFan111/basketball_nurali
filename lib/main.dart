import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';

import 'screens/auth/login_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProxyProvider<UserProvider, AuthProvider>(
          create: (context) => AuthProvider(
            Provider.of<UserProvider>(context, listen: false),
          ),
          update: (context, userProvider, authProvider) =>
              authProvider ?? AuthProvider(userProvider),
        ),
      ],
      child: const HoopConnectApp(),
    ),
  );
}

class HoopConnectApp extends StatelessWidget {
  const HoopConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HoopConnect',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepOrange[700],
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[900],
          selectedItemColor: Colors.deepOrange[600],
          unselectedItemColor: Colors.grey[400],
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const ScheduleScreen(), 
    const StatsScreen(), 
    const ProfileScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(_selectedIndex)),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_basketball_outlined),
            activeIcon: Icon(Icons.sports_basketball),
            label: 'Тренировки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Статистика',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Расписание тренировок';
      case 1:
        return 'Статистика';
      case 2:
        return 'Мой профиль';
      default:
        return 'HoopConnect';
    }
  }
}

