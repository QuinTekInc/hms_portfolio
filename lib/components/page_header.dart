import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hms_portfolio/bloc/navigation_bloc.dart';
import 'package:hms_portfolio/components/button.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'package:hms_portfolio/components/text.dart';
import 'package:hms_portfolio/components/shared_functions.dart';

class PageHeader extends StatefulWidget {

  const PageHeader({super.key});

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {


  List<HeaderMenuItem> get headerMenuItems => [
    HeaderMenuItem(  
      value: 1,
      title: 'Home', 
      onPressed: (){
        if(GoRouterState.of(context).name == 'home') return;
        context.go('/');
      }, 
      icon: Icons.home
    ),

    HeaderMenuItem(  
      value: 2,
      title: 'Our Services', 
      onPressed: (){
        if(GoRouterState.of(context).name == 'services') return;
        context.go('our-services');
      }, 
      icon: Icons.info
    ),


    HeaderMenuItem(  
      value: 3,
      title: 'News', 
      onPressed: () {
        if(GoRouterState.of(context).name == 'news') return;
        context.go('news');
      }, 
      icon: Icons.newspaper
    ),


    HeaderMenuItem(  
      value: 4,
      title: 'Events', 
      onPressed: () {
        if(GoRouterState.of(context).name == 'events') return;
        context.go('events');
      }, 
      icon: Icons.electric_bolt
    ),


    HeaderMenuItem( 
      value: 5, 
      title: 'Gallery',
      onPressed: () {
        if(GoRouterState.of(context).name == 'gallery') return;
        context.go('gallery');
      }
    ),


    HeaderMenuItem(  
      value: 6, 
      title: 'Book Appointment', 
      icon: Icons.book,
      onPressed: () => SharedFunctions.handleOpenBookAppointment(context), 
      isSpecialMenu: true
    )


  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.blue.shade900
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(  
              'assets/img/mcg-logo.png', 
              fit: BoxFit.cover,
              height: 50,
              width: 50,
            ),
          ),

          const SizedBox(width: 8,), 

          HeaderText(
            'Methodist Hospital Aburaso',
            textColor: Colors.white, 
            fontSize: ResponsiveUtil.sizeBasedValue(
              context: context,  
              mobileValue: 16.toDouble(), 
              desktopValue: 20.toDouble()
            )
          ),

          Spacer(), 


          LayoutBuilder(
            builder: (_, _){

              if(MediaQuery.of(context).size.width <= 720){
                return _buildMobileMenu();
              }


              return Row(  
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildDesktopMenu(context),
              );
            },
          )

         
        ],
      )
    );
  }

  List<Widget> _buildDesktopMenu(BuildContext context) {

    return headerMenuItems.indexed.map(((int, HeaderMenuItem) record) {

      final index = record.$1;
      final menuItem = record.$2;
      
      if(!menuItem.isSpecialMenu){
        return LinkButton(  
          onPressed: (){
            menuItem.onPressed();
            context.read<PageHeaderCubit>().setSelectedIndex(index);
          },
          text: menuItem.title,
          textColor: context.read<PageHeaderCubit>().state == index ? Colors.amber : Colors.white,
          fontWeight: context.read<PageHeaderCubit>().state == index ? FontWeight.w700 : null,
        );
      }


      return ElevatedButton(  
        onPressed: menuItem.onPressed,
        style: ElevatedButton.styleFrom(  
          padding: const EdgeInsets.symmetric(
            vertical: 8, 
            horizontal: 12
          ),
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          )
        ),
        child: CustomText(
          menuItem.title, 
          textColor: Colors.blue.shade900,
        ),
      );
    }).toList();
  }

  Widget _buildMobileMenu(){

    return PopupMenuButton(
      color: Colors.blue.shade800,
      menuPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade600, width: 1.5)
      ),

      icon: Container(  
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.transparent, 
          borderRadius: BorderRadius.circular(12),
          border: Border.all( 
            color: Colors.white, 
            width: 1.5
          )
        ),
        child: Icon(Icons.menu, color: Colors.white,),
      ),
      iconColor: Colors.white,

      borderRadius: BorderRadius.circular(12),

      padding: EdgeInsets.zero,


      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeIn, 
        duration: Duration(milliseconds: 200)
      ),


      itemBuilder: (_) => headerMenuItems.map((menuItem){
        return PopupMenuItem(
          value: menuItem.value,
          onTap: menuItem.onPressed,
          child: Container(
            padding: !menuItem.isSpecialMenu ? null : const EdgeInsets.all(8),
            decoration: !menuItem.isSpecialMenu ? null : BoxDecoration(  
              color: Colors.amber, 
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(  
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                if(menuItem.icon != null)
                  Icon(
                    menuItem.icon, 
                    size: 25, 
                    color: Colors.white,
                  )
                else 
                  SizedBox.shrink(), 
                
                CustomText(  
                  menuItem.title,
                  textColor: menuItem.isSpecialMenu ? Colors.blue.shade700 : Colors.white,
                )
              ],
            ),
          ),
        );
      }).toList()
    );
  }

}



class HeaderMenuItem{
  int value;
  final void Function() onPressed;
  final String title;
  final IconData? icon;
  final bool isSpecialMenu;


  HeaderMenuItem({
    required this.value,
    required this.title, 
    required this.onPressed, 
    this.icon, 
    this.isSpecialMenu = false,
  });
}