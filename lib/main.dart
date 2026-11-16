import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_portfolio/bloc/events_bloc.dart';
import 'package:hms_portfolio/bloc/navigation_bloc.dart';
import 'package:hms_portfolio/bloc/news_bloc.dart';
import 'package:hms_portfolio/bloc/services_bloc.dart';
import 'package:hms_portfolio/components/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../bloc/gallery_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'dev.env');
  runApp(HmsApp());
}

class HmsApp extends StatelessWidget {
  const HmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(

      providers: [
        
        BlocProvider(  
          create: (context) => PageHeaderCubit()
        ),


        BlocProvider(
          create: (context) => EventsCubit()..fetchEvents(),
        ),

        BlocProvider(  
          create: (context) => GalleryCubit()..fetchGalleryItems(),
        ),

        BlocProvider(  
          create: (context) => NewsCubit()..fetchNewsArticles(),
        ),


        BlocProvider(
          create: (context) => ServicesCubit()..fetchServices(),
        )

      ],

      child: MaterialApp.router(
        title: 'Methodist Hospital, Aburaso',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter
      ),
    );
  }
}
