
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hms_portfolio/components/button.dart';
import 'package:hms_portfolio/components/card_containers.dart';
import 'package:hms_portfolio/components/page_footer.dart';
import 'package:hms_portfolio/components/page_header.dart';
import 'package:hms_portfolio/components/text.dart';


class GalleryPage extends StatefulWidget {

  const new({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {

  int selectedIndex = 0;
  

  final categories = [
    'All', 
    'Facility', 
    'Staff'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: const PreferredSize(  
        preferredSize: Size.fromHeight(120),
        child: PageHeader(),
      ),
      body: CustomScrollView(  
        slivers: [

          SliverToBoxAdapter(  
            child: _buildBanner()
          ),



          SliverToBoxAdapter(  
            child: _buildCategoriesBanner(),
          ), 


          SliverToBoxAdapter(  
            child: _buildPhotosGrid(),
          ),


          const SliverToBoxAdapter(
            child: PageFooter(),
          )

        ],
      )
    );
  }


  Widget _buildBanner(){
    return Container(  
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      alignment: Alignment.center,
      
      decoration: BoxDecoration(  
        gradient: LinearGradient(  
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade900, Colors.amber, 
            Colors.amber.shade700, Colors.blue.shade900
          ]
        )
      ),

      child: Column(  
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          
          HeaderText.withResponsiveSize( 
            'Gallery', 
            textColor: Colors.white
          ), 

          const CustomText(
            'Share Our Memories with us.', 
            textColor: Colors.white,
          )

        ],
      ),
    );
  }



  Widget _buildCategoriesBanner(){

    return SectionContainer(
      backgroundColor: Colors.grey.shade200,
      child: Center(

        child: ConstrainedBox(

          constraints: BoxConstraints(  
            maxHeight: 35,
            minHeight: 35, 
            maxWidth: 1100
          ),


          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,

            itemBuilder: (context, index){
              String category = categories[index];
              return CustomChip(  
                text: category,
                isSelected: selectedIndex == index,
                selectedBackgroundColor: Colors.blue.shade900,
                onPressed: () => setState(() => selectedIndex = categories.indexOf(category)),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 12,),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotosGrid(){

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      alignment: Alignment.center,
      child: Column(  
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [

          HeaderText('No Images yet'), 
          const CustomText('Images in the gallery appear here.')

        ],
      ),
    );
  }


  


}