import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_chat/auth.dart';
import 'package:video_chat/cubits/auth_cubit/auth_cubit.dart';
import 'package:video_chat/cubits/stream/stream_cubit.dart';
import 'package:video_chat/cubits/stream_list/stream_list_cubit.dart';
import 'package:video_chat/repositories/auth_repository.dart';
import 'package:video_chat/repositories/stream_repository.dart';
import 'package:video_chat/screens/auth_screens/auth_screens.dart';
import 'package:video_chat/screens/auth_screens/sign_in_screen.dart';
import 'package:video_chat/screens/home_screen.dart';
import 'package:video_chat/utils/meta_assets.dart';
import 'package:video_chat/utils/meta_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => StreamRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthCubit(context.read<AuthRepository>())..initAuth(),
          ),
          BlocProvider(
              create: (context) =>
                  StreamListCubit(context.read<StreamRepository>())),
          BlocProvider(
              create: (context) =>
                  StreamCubit(context.read<StreamRepository>()))
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            iconTheme: const IconThemeData(color: MetaColors.primaryColor),
            primaryColor: MetaColors.primaryColor,
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: Colors.white,

            textTheme: const TextTheme(),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedLabelStyle:
                    TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(fontSize: 10),
                backgroundColor: MetaColors.primaryColor,
                selectedItemColor: Colors.white,
                elevation: 0,
                unselectedItemColor: Colors.white30),
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(color: MetaColors.primaryColor)),
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the applicati
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool endSplash = true;
  @override
  void initState() {
    initSplash();
  }

  initSplash() async {
    await Future.delayed(Duration(seconds: 2), () {
      setState(() {
        endSplash = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !endSplash
          ? Scaffold(
              body: Center(child: Text("Splash Screen")),
            )
          : Auth(),
    );
  }
}
