import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package; flutter/material.dart';
import 'firebase_options.dart';
import 'package: firebase_core/ firebasebase_core.dart';
import 'package: provider/provider.dart';

import 'services/auth_service.dart';
import 'app/app_router.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initalizeApp( //initiliaze firebase
    options: DefaultFirebaseOptions.currentPlatform,

  );


  runApp(const FocusNFlowApp());
  


  
}


class FocusNFlowApp extends StatefulWidget{
  const FocusNFlowApp({super.key});
  @override

  State<FocusNFlowApp> createState() => _FocusnFlowAppState();
}

class FocusNFlowApp extends StatefulWidget{
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme(){
    setState((){
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override

  //ui
  Widget build(BuildContext context){
    return MultiProvider(providers:
    [ChangeNotifierProvider(create: (_) => AuthService(),),
    Provider<Funtion>(create: (_) => _toogleTheme,),
    ]
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FocusNFLow',
      themeMode: _themeMode,
      theme: AppTheme.dark,
      lightTheme:Apptheme.lightTheme,


      //initalscreen and router generater
      home: const SplashScreen(),
      onGenerateRoute: AppRouter.generateRoute,

    ),
    );
  }
}