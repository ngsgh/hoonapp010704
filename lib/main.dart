import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'shared/widgets/navigation/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '스마트 냉장고',
      theme: AppTheme.theme,
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  // 각 탭에 해당하는 페이지 위젯들
  final List<Widget> _pages = [
    const Center(child: Text('홈')),
    const Center(child: Text('쇼핑')),
    const Center(child: Text('등록')),
    const Center(child: Text('레시피')),
    const Center(child: Text('상품정보')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex], // 선택된 인덱스의 페이지만 표시
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
