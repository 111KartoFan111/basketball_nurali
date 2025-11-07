import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/analytics_provider.dart';
import 'services/api_service.dart';

import 'screens/auth/login_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/user_analytics_screen.dart';
import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize locale/date formatting
  await initializeDateFormatting();

  // Load saved token before running the app
  final apiService = ApiService();
  await apiService.loadToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider('http://localhost:8080')),
      ],
      child: const HoopConnectApp(),
    ),
  );

}

class HoopConnectApp extends StatefulWidget {
  const HoopConnectApp({super.key});

  @override
  State<HoopConnectApp> createState() => _HoopConnectAppState();
}

class _HoopConnectAppState extends State<HoopConnectApp> {
  bool _checkingAuth = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final apiService = ApiService();

    if (!apiService.isAuthenticated) {
      setState(() {
        _checkingAuth = false;
        _isAuthenticated = false;
      });
      return;
    }

    try {
      final resp = await apiService.get('users/me');
      if (resp is Map<String, dynamic>) {
        final user = UserModel.fromJson(resp);
        if (mounted) {
          Provider.of<UserProvider>(context, listen: false).setUser(user);
        }
      }

      if (mounted) {
        setState(() {
          _checkingAuth = false;
          _isAuthenticated = true;
        });
      }
    } catch (e) {
      await apiService.setToken(null);
      if (mounted) {
        setState(() {
          _checkingAuth = false;
          _isAuthenticated = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HoopConnect',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepOrange[700],
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: _checkingAuth
          ? const _LoadingScreen()
          : (_isAuthenticated ? const MainAppShell() : const LoginScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Загрузка...', style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      ),
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
  bool _isCoach = false;
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    super.initState();
    _loadUserRoleAndBuildTabs();
  }

  Future<void> _loadUserRoleAndBuildTabs() async {
    try {
      final apiService = ApiService();
      final resp = await apiService.get('users/me');
      String role = 'USER';
      if (resp is Map<String, dynamic> && resp.containsKey('role')) {
        role = resp['role'] as String;
      }

      _isCoach = role == 'COACH';
      _updateWidgetOptions();
    } catch (e) {
      _isCoach = false;
      _updateWidgetOptions();
    }
  }

  void _updateWidgetOptions() {
    final baseOptions = <Widget>[
      const ScheduleScreen(),
      const StatsScreen(),
      const ProfileScreen(),
    ];

    if (_isCoach) {
      baseOptions.insert(1, const UserAnalyticsScreen());
    }

    setState(() {
      _widgetOptions = baseOptions;
      if (_selectedIndex >= _widgetOptions.length) _selectedIndex = 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.sports_basketball_outlined),
        activeIcon: Icon(Icons.sports_basketball),
        label: 'Тренировки',
      ),
    ];

    if (_isCoach) {
      items.add(const BottomNavigationBarItem(
        icon: Icon(Icons.analytics_outlined),
        activeIcon: Icon(Icons.analytics),
        label: 'Аналитика',
      ));
    }

    items.addAll([
      const BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart_outlined),
        activeIcon: Icon(Icons.bar_chart),
        label: 'Статистика',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Профиль',
      ),
    ]);

    return items;
  }

  String _getAppBarTitle(int index) {
    if (_widgetOptions.isEmpty) return '';

    if (_isCoach) {
      switch (index) {
        case 0:
          return 'Расписание тренировок';
        case 1:
          return 'Аналитика пользователей';
        case 2:
          return 'Статистика';
        case 3:
          return 'Мой профиль';
        default:
          return '';
      }
    }

    switch (index) {
      case 0:
        return 'Расписание тренировок';
      case 1:
        return 'Статистика';
      case 2:
        return 'Мой профиль';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(_selectedIndex)),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _widgetOptions.isEmpty
            ? const CircularProgressIndicator()
            : _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _buildNavigationItems(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}