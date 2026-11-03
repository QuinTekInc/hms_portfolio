import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/alert.dart';
import 'package:hms_portfolio/components/button.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'package:hms_portfolio/components/shared_functions.dart';
import 'package:hms_portfolio/components/text.dart';
import 'package:hms_portfolio/bloc/repo.dart';

class PageFooter extends StatefulWidget {
  const PageFooter({super.key});

  @override
  State<PageFooter> createState() => _PageFooterState();
}

class _PageFooterState extends State<PageFooter> {
  final emailController = TextEditingController();

  @override 
  void dispose(){
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      color: Colors.blue.shade900,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [

          ResponsiveGrid(  
            children: [
              _buildFooterLogo(), 
              _buildQuickLinks(context), 
              _buildContact(), 
              _buildNewsLetterSubscribe()
            ],
          ), 


          const SizedBox( 
            height: 24,
          ),


          Divider(
            color: Colors.white.withValues(alpha: 0.2),
          ), 

          const SizedBox(height: 12,),

          CustomText(
            '© Aburaso Methodist Hospital, 2026. All rights resevered.', 
            textColor: Colors.white70, 
            textAlignment: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLogo() {
    return SizedBox(
      width: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [

              Image.asset(
                'assets/img/mcg-logo.png', 
                height: 90, 
                width: 90, 
                fit: BoxFit.cover
              ),

              Expanded(
                child: HeaderText(
                  'Methodist Hospital Aburaso', 
                  textColor: Colors.white,
                  softwrap: true
                ),
              ), 
            ],
          ),
      
          CustomText(  
            'Providing hoslistic healthcare services to '
            'transform lives and promote human dignity.', 
            textColor: Colors.white70,
            
          )
        ],
      ),
    );
  }

  Widget _buildQuickLinks(BuildContext context){


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [

        HeaderText(
          'Quick Links', 
          textColor: Colors.amber, 
          fontSize: 18
        ), 

        LinkButton(  
          text: 'Home',
          textColor: Colors.white,
          onPressed: (){},
        ), 

        LinkButton(  
          text:'News',
          textColor: Colors.white,
          onPressed: (){},
        ), 

        LinkButton(  
          text:'Events',
          textColor: Colors.white,
          onPressed: (){},
        ), 


        LinkButton(  
          text:'Gallery',
          textColor: Colors.white,
          onPressed: (){},
        ), 


        ElevatedButton(
          onPressed: () => SharedFunctions.handleOpenBookAppointment(context),
          style: ElevatedButton.styleFrom(  
            elevation: 3,
            backgroundColor: Colors.amber,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            )
          ),
          child: CustomText('Book Appointment'),
        )
      ],
    );
  }

  Widget _buildContact() {
    
    final contactInfo = [
      (Icons.phone, 'Administration', '+233 50 236 1706'),
      (Icons.emergency, 'Emergency', '+233 50 236 1709'), 
      (Icons.pregnant_woman, 'Maternity', '+233 50 236 1700'), 
      (Icons.alternate_email, 'E-Mail', 'aburasomethodisthospital1@gmail.com'), 
      (Icons.email, 'Post Address', 'P.O Box 1956, Kumasi'), 
      (Icons.location_on, 'Digital Address', 'AG-0576-7064')
    ];


    final desktopWidget = Column(  
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contactInfo.map((info){

        final icon = info.$1;
        final title = info.$2;
        final detail = info.$3;

        return Row(  
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: .center,
          children: [
            Icon(icon, color: Colors.amber, size: 24,),

            const SizedBox(width: 12,),

            Expanded(  
              child: CustomText(  
                '$title:',
                padding: EdgeInsets.zero,
                textColor: Colors.white,
                fontSize: 14,
              ),
            ), 

            Expanded( 
              flex: 2, 
              child: CustomText(
                detail, 
                padding: EdgeInsets.zero,
                textColor: Colors.white,
                textAlignment: TextAlign.left,
                fontSize: 14,
              ),
            )
          ],
        );
      }).toList()
    );

    return Column(
      spacing: 3, 
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, 
      children: [
        
        HeaderText(  
          'Contact', 
          textColor: Colors.amber, 
          fontSize: 18
        ), 

       
        desktopWidget
      ],
    );
  }

  Widget _buildNewsLetterSubscribe(){
    return Column(  
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        HeaderText(
          'Subcribe to our news letter',
          textColor: Colors.amber, 
          fontSize: 18
        ), 
        CustomText(  
          'Stay updated with our lastest health initiatives and news', 
          textColor: Colors.white70,
        ),
        Row( 
          mainAxisSize: MainAxisSize.min, 
          children: [
            Expanded(
              child: CustomTextField(
                controller: emailController,
                leadingIcon: Icons.alternate_email,
                margin: EdgeInsets.zero,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                useLabel: false,
                hintText: 'Enter email (example@gmail.com)',
              ),
            ), 

            SizedBox(
              height: 49,
              width: 50,
              child: FloatingActionButton(
                elevation: 0,
                onPressed: _handleNewsLetterSub,
                shape: RoundedRectangleBorder( 
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(12))
                ),
                backgroundColor: Colors.amber,
                child: Icon( 
                  Icons.send, 
                  color: Colors.white,
                ),
              ),
            ) 
          ],
        )
      ],
    );
  }

  void _handleNewsLetterSub() async {

    showLoadingDialog(
      context: context, 
      title: 'Newsletter Subscription', 
      contentText: 'Submitting application...Please wait'
    );


    try{
      await Repository.subscribeNewsLetter(emailController.text);
      Navigator.pop(context); //close the loading dialog.

    }catch(ex){
      Navigator.pop(context); //close the loading dialog. 
      await showAlertDialog(  
        context: context, 
        alertType: AlertType.error,
        title: 'Error', 
        contentText: 'An unexpected error occurred while sending subscription'
      );

      return;
    }


    await showAlertDialog(  
      context: context, 
      alertType: AlertType.success,
      title: 'Newsletter subscription', 
      contentText: 'Subscription to the MHA newsletter sucessful'
    );

    setState(() => emailController.clear());

  }
}
