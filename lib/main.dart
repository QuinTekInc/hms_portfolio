import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_portfolio/bloc/navigation_bloc.dart';
import 'package:hms_portfolio/components/app_router.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(HmsApp());
}

class HmsApp extends StatelessWidget {
  const HmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      
      create: (_) => PageHeaderCubit(),

      child: MaterialApp.router(
        title: 'Methodist Hospital, Aburaso',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter
      ),
    );
  }
}
