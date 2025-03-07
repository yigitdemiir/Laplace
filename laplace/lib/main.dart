import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'models/cart_item_model.dart';
import 'presentation/pages/main/main_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'providers/cart_provider.dart';
import 'providers/address_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'presentation/pages/product/test_product_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('Initializing Firebase...'); // Debug log
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully'); // Debug log
  } catch (e) {
    print('Error initializing Firebase: $e'); // Debug log
    rethrow;
  }

  // Initialize Hive for cart storage
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CartItemModelAdapter());
  }
  await Hive.openBox<CartItemModel>('cart');
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AddressProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProductProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Laplace',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: authProvider.isAuthenticated
                ? const MainPage()
                : const LoginPage(),
            routes: {
              '/home': (context) => const MainPage(),
              '/test_products': (context) => const TestProductScreen(),
            },
          );
        },
      ),
    );
  }
}
