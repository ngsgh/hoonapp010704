import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'features/home/domain/models/product.dart';
import 'features/home/presentation/providers/product_provider.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/shopping/presentation/pages/shopping_page.dart';
import 'features/recipe/presentation/pages/recipe_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/settings/presentation/providers/notification_settings_provider.dart';
import 'features/settings/presentation/providers/backup_provider.dart';
import 'features/product_template/domain/models/product_template.dart';
import 'features/product_template/presentation/providers/product_template_provider.dart';
import 'shared/widgets/navigation/bottom_nav_bar.dart';
import 'features/product_master/domain/models/product_master.dart';
import 'features/product_master/presentation/providers/product_master_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ProductTemplateAdapter());
  Hive.registerAdapter(ProductMasterAdapter());

  final productBox = await Hive.openBox<Product>('products');
  final settingsBox = await Hive.openBox('settings');
  final templateBox = await Hive.openBox<ProductTemplate>('templates');
  final masterBox = await Hive.openBox<ProductMaster>('product_masters');

  // 마스터 데이터가 없으면 초기 데이터 추가
  if (masterBox.isEmpty) {
    await masterBox.addAll([
      ProductMaster(
        name: '서울우유',
        category: '유제품',
        storeName: '이마트',
        purchaseUrl: 'https://emart.ssg.com/item/0000006284195',
      ),
      ProductMaster(
        name: '연세우유',
        category: '유제품',
        storeName: '쿠팡',
        purchaseUrl: 'https://www.coupang.com/vp/products/1234567890',
      ),
      ProductMaster(
        name: '매일우유',
        category: '유제품',
        storeName: '홈플러스',
        purchaseUrl: 'https://front.homeplus.co.kr/item/1234567890',
      ),
      ProductMaster(
        name: '삼다수',
        category: '음료',
      ),
      ProductMaster(
        name: '에비앙',
        category: '음료',
      ),
      ProductMaster(
        name: '콜라',
        category: '음료',
      ),
      ProductMaster(
        name: '사과',
        category: '과일',
      ),
      ProductMaster(
        name: '바나나',
        category: '과일',
      ),
      ProductMaster(
        name: '오렌지',
        category: '과일',
      ),
      ProductMaster(
        name: '양파',
        category: '채소',
      ),
      ProductMaster(
        name: '감자',
        category: '채소',
      ),
      ProductMaster(
        name: '당근',
        category: '채소',
      ),
      ProductMaster(
        name: '돼지고기',
        category: '육류',
      ),
      ProductMaster(
        name: '소고기',
        category: '육류',
      ),
      ProductMaster(
        name: '닭고기',
        category: '육류',
      ),
      ProductMaster(
        name: '연어',
        category: '해산물',
      ),
      ProductMaster(
        name: '고등어',
        category: '해산물',
      ),
      ProductMaster(
        name: '새우',
        category: '해산물',
      ),
    ]);
  }

  runApp(MainApp(
    productBox: productBox,
    settingsBox: settingsBox,
    templateBox: templateBox,
    masterBox: masterBox,
  ));
}

class MainApp extends StatelessWidget {
  final Box<Product> productBox;
  final Box settingsBox;
  final Box<ProductTemplate> templateBox;
  final Box<ProductMaster> masterBox;

  const MainApp({
    super.key,
    required this.productBox,
    required this.settingsBox,
    required this.templateBox,
    required this.masterBox,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider(productBox)),
        ChangeNotifierProvider(
            create: (_) => NotificationSettingsProvider(settingsBox)),
        ChangeNotifierProvider(create: (_) => BackupProvider()),
        ChangeNotifierProvider(
            create: (_) => ProductTemplateProvider(templateBox)),
        ChangeNotifierProvider(create: (_) => ProductMasterProvider(masterBox)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const RootPage(),
        theme: ThemeData(
          useMaterial3: false,
        ),
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ShoppingPage(),
    SizedBox.shrink(),
    RecipePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
