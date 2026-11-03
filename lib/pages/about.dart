
import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/page_footer.dart';
import 'package:hms_portfolio/components/page_header.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'package:hms_portfolio/components/text.dart';

class AboutPage extends StatelessWidget {

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: PreferredSize(  
        preferredSize: Size.fromHeight(120),
        child: PageHeader(),
      ), 
      body: SingleChildScrollView(
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 12,
          children: [

            _buildCover(context),


            PageFooter()
          ],
        ),
      ),
    );
  }


  Widget _buildCover(BuildContext context){

    return Container(  
      padding: EdgeInsets.all(
        ResponsiveUtil.sizeBasedValue(
          context: context, 
          mobileValue: 24.0, 
          desktopValue: 36.0
        )
      ),
      height: MediaQuery.of(context).size.height * 0.3,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/doctor.jpg'),
          fit: BoxFit.cover, 
          colorFilter: ColorFilter.mode( 
            Colors.blue.shade900, 
            BlendMode.darken
          )
        )
      ),
      child: HeaderText(  
        'About MHA', 
        textColor: Colors.white
      ),
    );
  }
}