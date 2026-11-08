import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/page_header.dart';
import 'package:hms_portfolio/pages/claude_appointment.dart';
import 'package:hms_portfolio/pages/claude_services.dart' hide OurServicesPage;
import 'package:hms_portfolio/pages/events_page.dart';
import 'package:hms_portfolio/pages/gallery_page.dart';
import 'package:hms_portfolio/components/text.dart';
import 'package:hms_portfolio/pages/homepage.dart';
import 'package:hms_portfolio/pages/news_page.dart';
import 'package:hms_portfolio/pages/our_services.dart';
import 'package:hms_portfolio/pages/error_page.dart' as errorPage;


final appRouter = GoRouter(
  initialLocation:  '/',
  routes: [

    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) {
        return Homepage();
      },
    ),

    GoRoute( 
      path: '/claude-appointment',
      builder: (context, state) => const AppointmentFormPage()
    ),

    GoRoute( 
      path: '/our-services', 
      name: 'services',
      builder: (context, state){
        return  OurServicesPage();
      }
    ),

    GoRoute( 
      path: '/news', 
      name: 'news',
      builder: (_, state) => const NewsPage()
    ),

    GoRoute(  
      path: '/gallery', 
      name: 'gallery',
      builder: (context, state){
        return const GalleryPage();
      }
    ),


    GoRoute(  
      path: '/events', 
      name: 'events',
      builder: (context, state){
        return const EventsPage();
      }
    ),

    GoRoute(
      path: '/programming',
      builder: (context, state) {
        return Container(child: Text('This is the programming and algorithms'));
      },
    ),
  ],

  errorBuilder: (context, state) {
    return errorPage.Error404Page(
      onGoHome: () => context.goNamed('home'),
    );
  },
);

//building for 404 page.
class Error404Page extends StatelessWidget {

  const Error404Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const  PreferredSize(  
        preferredSize: Size.fromHeight(120),
        child: PageHeader(),
      ),
      body: const Center(  
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeaderText('Oops!...'),
            CustomText('The requested page or resource does not exist')
          ],
        ),
      ),
    );
  }
}


