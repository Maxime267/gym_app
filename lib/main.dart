import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/presentation/screen/home_page.dart';
import 'logic/bloc/drawer.dart';
import 'logic/notifier/themeNotifier.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeNotifier = ThemeNotifier();

  final drawerBloc = DrawerBloc();
  drawerBloc.add(LoadSavedSessionsEvent()); // ← on prépare le Drawer

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeNotifier),
        BlocProvider(create: (_) => drawerBloc),
      ],
      child: const MyApp(),
    ),
  );
}
/*
void main2() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child :
      BlocProvider(
        create: (context) => DrawerBloc(),
        child: MaterialApp(
          title: 'Gym App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: HomePage(),
      ),
      )
    )
  );
}
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return
      BlocProvider(
        create: (context) => DrawerBloc(),
        child: MaterialApp(
          title: 'Gym App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeNotifier.themeMode,
          home: HomePage(),
        ),
      );
  }
}