
import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/card_containers.dart';
import 'package:hms_portfolio/components/constants.dart';
import 'package:hms_portfolio/components/page_footer.dart';
import 'package:hms_portfolio/components/page_header.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'package:hms_portfolio/components/text.dart';


class OurServicesPage extends StatelessWidget{

  const OurServicesPage({super.key});

  @override  
  Widget build(BuildContext context){

    return Scaffold(

      appBar: const PreferredSize( 
        preferredSize: Size.fromHeight(120), 
        child: PageHeader(),
      ),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(  
            child: _buildCover(context),
          ), 

          SliverToBoxAdapter(  
            child: _buildGeneralServices(context),
          ),

          SliverToBoxAdapter(  
            child: _buildSpecializedServices(context),
          ), 


          const SliverToBoxAdapter(  
            child: PageFooter()
          )
        ],
      ),
    );
  }

  Widget _buildCover(BuildContext context){
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.2,
      padding: const EdgeInsets.symmetric( 
        vertical: 24, 
        horizontal: 36, 
      ),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        image: DecorationImage(  
          image: AssetImage('assets/img/surgery.jpg'), 
          fit: BoxFit.cover, 
          colorFilter: ColorFilter.mode(  
            Colors.blue.shade900.withOpacity(0.6), 
            BlendMode.darken
          )
        )
      ),
      child: HeaderText(  
        'Our Services', 
        textAlignment: TextAlign.center, 
        fontSize: 24, 
        textColor: Colors.white
      )
    );
  }


  Widget _buildGeneralServices(BuildContext context){

    final gridView = GridView.count( 
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: ResponsiveUtil.sizeBasedValue(context: context, desktopValue: 3, mobileValue: 2), 
      mainAxisExtent: 40,
      mainAxisSpacing: 8,
      children: generalServices.map((serviceItem) => 
        Row( 
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 5, 
          children: [
            Container(  
              padding: EdgeInsets.all(
                ResponsiveUtil.sizeBasedValue(
                  context: context, 
                  mobileValue: 4, 
                  desktopValue: 8
                ).toDouble()
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                shape: BoxShape.circle, 
              ),
            ),

            Expanded(
              child: CustomText(
                serviceItem,
                fontSize: 14,
                textColor: Colors.white,
              ),
            ),
          ],
         
        )
      ).toList()
    );


    return SectionContainer(
      backgroundColor: Colors.amber,
      child: Column(  
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
      
          HeaderText(
            'General Services', 
            textColor: Colors.blue.shade900
          ), 
      
          const SizedBox(  
            height: 8,
          ),
      
          ResponsiveUtil.sizeBasedValue(
            context: context, 
            mobileValue: gridView, 
            desktopValue: Center( 
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: gridView,
              )
            )
          ), 
      
        ],
      ),
    );
  }


  Widget _buildSpecializedServices(BuildContext context){


    final spacing = ResponsiveUtil.sizeBasedValue(
      context: context, 
      mobileValue: 8, 
      desktopValue: 12
    ).toDouble();


    final gridView = GridView.count(  
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: ResponsiveUtil.sizeBasedValue(  
        context: context,
        mobileValue: 2, 
        desktopValue: 4
      ),
      mainAxisExtent: 250,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children: specialServicesList.map((serviceItem){

        String text = serviceItem.$1;
        String imagePath = serviceItem.$2;


        return _ServiceTile(  
          text: text,
          imagePath: imagePath,
        );

      }).toList(),
    );

    return SectionContainer(
      child: Column(  
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          HeaderText('Special Services'),
      
          const SizedBox(height: 8,),
      
          ResponsiveUtil.sizeBasedValue(
            context: context,
            mobileValue: gridView, 
            desktopValue: Center(  
              child: SizedBox(  
                width: MediaQuery.of(context).size.width * 0.8,
                child: gridView,
              ),
            )
          )
        ],
      ),
    );
  }
}


class _ServiceTile extends StatefulWidget {

  const _ServiceTile({required this.text, required this.imagePath});

  final String text;
  final String imagePath;

  @override
  State<_ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends State<_ServiceTile> {
  
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(

      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),

      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),

          child: AnimatedScale(
            scale: _isHovered ? 1.06 : 1,
            duration: Duration(milliseconds: 200),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  cacheWidth: 600, // decode at ~tile size, not full size
                  filterQuality: FilterQuality.low,
                ),
                const ColoredBox(color: Colors.black54), // cheap "darken"
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomText(
                      widget.text,
                      fontSize: 15,
                      textColor: Colors.white,
                      softwrap: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}