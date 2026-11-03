
import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/animations.dart';
import 'package:hms_portfolio/components/button.dart';
import 'package:hms_portfolio/components/card_containers.dart';
import 'package:hms_portfolio/components/constants.dart';
import 'package:hms_portfolio/components/news_card.dart';
import 'package:hms_portfolio/components/page_footer.dart';
import 'package:hms_portfolio/components/page_header.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'package:hms_portfolio/components/text.dart';

import '../models/models.dart';


class NewsPage extends StatefulWidget{
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}


class _NewsPageState extends State<NewsPage>{

  //final _newsSearchController = TextEditingController();

  int _selectedIndex = 0;

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
            child: _buildBanner(),
          ),

          SliverAppBar(
            pinned: true,
            centerTitle: true,
            backgroundColor: Colors.grey.shade200,
            leading: null,
            title: _buildCategoryChips(),
          ),


          SliverToBoxAdapter( 
            child: _buildNewsContent(context),
          ),


          SliverToBoxAdapter(
            child: const PageFooter(),
          )
        ],
      )
    );
  }


  Widget _buildBanner(){

    return SizedBox(  
      child: Container( 
        padding: EdgeInsets.symmetric(
          vertical: 36, 
          horizontal: ResponsiveUtil.isMobile(context) ? 12: 0 
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(  
          gradient: LinearGradient( 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade900, Colors.amber.shade600]
          )
        ),

        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(  
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber, width: 1.5),
                borderRadius: BorderRadius.circular(24), 
                color: Colors.amber.withAlpha(30)
              ),
              child: CustomText(  
                'News & Articles',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: Colors.amber,
              ),
            ),

            
            HeaderText(
              'The Latest from Our Hospital', 
              textColor: Colors.white, 
              textAlignment: TextAlign.center,
              fontSize: fluidInterpolation(context, 30, 50)
            ), 

            CustomText(
              'Announcements, Health advice, research and stories from our community',
              padding: EdgeInsets.zero,
              textColor: Colors.white,
              textAlignment: TextAlign.center,
              fontSize: fluidInterpolation(context, 15, 18),
            ),


            // FractionallySizedBox(
            //   widthFactor: fluidInterpolation(context, 1, 0.6),
            //   child: CustomTextField(  
            //     controller: _newsSearchController,
            //     useLabel: false,
            //     hintText: 'Search news and articles',
            //     leadingIcon: Icons.search,
            //     borderRadius: BorderRadius.circular(24),
            //   ),
            // ),

            const SizedBox(  
              height: 12,
            ),

            revealAnimationWidget(
              child: FractionallySizedBox(
                widthFactor: fluidInterpolation(context, 1, 0.6),
                child: FeaturedNewsCard(
                  article: sampleNews[0], 
                  onTap: (changed){}
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



  Widget _buildCategoryChips(){


    final newsCategories =<(String, IconData?, Color, NewsCategory?)> [
      ('All', null, Colors.blue.shade900, null), 
      for (final c in NewsCategory.values) (c.label, c.icon, c.color, c),
    ];

    final chips = newsCategories.map((category) {
      final (label, icon, color, c) = category;

      return CustomChip(
        text: label, 
        icon: icon,
        hoverBackgroundColor: color.withAlpha(150),
        selectedBackgroundColor: color,
        isSelected: _selectedIndex == newsCategories.indexOf(category),
        onPressed: () => setState(() => _selectedIndex = newsCategories.indexOf(category)),
      );
    }).toList();


    return SectionContainer(  
      backgroundColor: Colors.grey.shade200,
      child: Center(  
        child: ConstrainedBox(  
          constraints: BoxConstraints(  
            maxWidth: 1100, 
            maxHeight: 35,
            minHeight: 35
          ),

          child: ListView.separated( 
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: chips.length,  
            itemBuilder: (_, index) => chips[index],
            separatorBuilder: (_, index) => SizedBox(width: 8,),
          ),
        ),
      ),
    );

  }



  Widget _buildNewsContent(BuildContext context){
    return SectionContainer(
      child: FractionallySizedBox(
        widthFactor: fluidInterpolation(context, 1, 0.6),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: ResponsiveGrid.builder(
            itemCount: sampleNews.length,
            minItemWidth: 350,
            itemBuilder: (_, index) => SizedBox(
              height: 400,
              child: revealAnimationWidget(
                child: NewsCard(  
                  article: sampleNews[index],
                  onTap: (newValue){},
                ),
              )
            ),
          
          ),
        ),
      ),
    );
  }
}



class NewsItem extends StatelessWidget {

  final String? coverImagePath;
  final String title;
  final String detail;

  const new({
    super.key, 
    this.coverImagePath,
    required this.title, 
    this.detail = ''
  });

  @override
  Widget build(BuildContext context) {
    return Container(  
      decoration: BoxDecoration(  
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(  
        mainAxisAlignment: MainAxisAlignment.start, 
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          
          //replace this with cached network image.
          Container(  
            height: ResponsiveUtil.isDesktop(context) ? 230 : 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), 
                topRight: Radius.circular(12)
              ), 
              image: DecorationImage(
                image: AssetImage('assets/img/doctor.jpg'), 
                fit: BoxFit.cover
              )
            ),
          ),



          Expanded(
            child: Container(  
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(  
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                color: Colors.blue.shade700
              ),
            
              child: Column(  
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: CustomText(
                      title, 
                      maxLines: 2,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      padding: EdgeInsets.zero,
                      textColor: Colors.white,
                    ),
                  ), 

                  Expanded(
                    flex: 2,
                    child: CustomText(  
                      detail, 
                      padding: EdgeInsets.zero,
                      softwrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      fontSize: 14,
                      textColor: Colors.white,
                    ),
                  ), 


                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(  
                      onPressed: handleOpenNewsItem,
                      label: CustomText('Read More', textColor: Colors.amber,),
                      icon: Icon(Icons.keyboard_arrow_right_rounded, color: Colors.amber,),
                      iconAlignment: IconAlignment.end,
                    ),
                  )
                  
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  void handleOpenNewsItem() async {

  }
}