
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hms_portfolio/bloc/appointment_bloc.dart';
import 'package:hms_portfolio/pages/appointment_page.dart';
import 'responsive_util.dart';


class SharedFunctions {
  
  static Future<void> handleOpenBookAppointment(BuildContext context) async {

    await showDialog(  
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => AppointmentCubit(),

        child: Dialog(  
          elevation: 5,
          shape: RoundedRectangleBorder(  
            borderRadius: BorderRadius.circular(12), 
          ),

          child: ConstrainedBox(
            constraints: BoxConstraints(
              
              maxWidth: ResponsiveUtil.sizeBasedValue(
                context: context,
                mobileValue: double.infinity, 
                desktopValue: MediaQuery.of(context).size.width * 0.5, 
              ), 

              maxHeight: ResponsiveUtil.sizeBasedValue( 
                context: context,
                desktopValue: MediaQuery.of(context).size.height * 0.6, 
                mobileValue: double.infinity
              )
            ),
            child: BookAppointPage()
          ),
        ),
      )
    );

  }


  static void navigateToNews(BuildContext context, {Key? key}){
    if(GoRouterState.of(context).name == 'news'){}
  }


}