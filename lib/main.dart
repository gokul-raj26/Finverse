import 'package:finverse/providers/asset_provider.dart';
import 'package:finverse/providers/debt_provider.dart';
import 'package:finverse/screens/add_asset_screen.dart';
import 'package:finverse/screens/asset_view_screen.dart';
import 'package:finverse/screens/dashboard_screen.dart';
import 'package:finverse/screens/debt_screen.dart';
import 'package:finverse/services/db_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local DB only for mobile (sqflite not supported on web)
  if (!kIsWeb) {
    await DBService.instance.init();
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Only show DevicePreview in debug mode
      builder: (context) => const FinverseApp(),
    ),
  );
}

class FinverseApp extends StatelessWidget {
  const FinverseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssetProvider()..loadAssets()),
        ChangeNotifierProvider(create: (_) => DebtProvider()..loadDebts()),
      ],
      child: MaterialApp(
        title: 'Finverse',
        theme: ThemeData(
          primarySwatch: Colors.red,
          useMaterial3: true,
        ),
        // 👇 Required for DevicePreview
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,

        initialRoute: DashboardScreen.routeName,
        routes: {
          DashboardScreen.routeName: (_) => const DashboardScreen(),
          AddAssetScreen.routeName: (_) => const AddAssetScreen(),
          DebtScreen.routeName: (_) => const DebtScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AssetViewScreen.routeName) {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => AssetViewScreen(assetId: args['id'] as int),
            );
          }
          return null;
        },
      ),
    );
  }
}
