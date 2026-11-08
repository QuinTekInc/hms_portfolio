
import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/animations.dart';
import 'package:hms_portfolio/components/button.dart';
import 'package:hms_portfolio/components/card_containers.dart';
import 'package:hms_portfolio/components/page_footer.dart';
import 'package:hms_portfolio/components/page_header.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'package:hms_portfolio/components/text.dart';
import 'package:hms_portfolio/models/models.dart';

class EventsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  int _selectedIndex = 0;

  final sampleEvents = [
    HospitalEvent(
    title: 'Diabetes Awareness Talk',
    description:
        'Learn how to recognise early signs, manage blood sugar and eat well with our endocrinology team.',
    date: DateTime(2026, 11, 7),
    time: '10:00 AM',
    location: 'Main Auditorium',
    category: EventCategory.healthTalk,
  ),
    HospitalEvent(
      title: 'Free Blood Pressure Screening',
      description:
          'Walk in for a quick, free check-up with our nurses. No appointment needed.',
      date: DateTime(2026, 11, 12),
      time: '8:00 AM',
      location: 'Outpatient Lobby',
      category: EventCategory.screening,
    ),
    HospitalEvent(
      title: 'First Aid & CPR Workshop',
      description:
          'Hands-on training in life-saving skills for schools, workplaces and families.',
      date: DateTime(2026, 11, 19),
      time: '2:00 PM',
      location: 'Training Room B',
      category: EventCategory.training,
    ),
    HospitalEvent(
      title: 'Community Health Walk',
      description:
          'Join staff and neighbours for a friendly 5 km walk promoting an active lifestyle.',
      date: DateTime(2026, 11, 28),
      time: '6:30 AM',
      location: 'Hospital Gate',
      category: EventCategory.community,
    ),
    HospitalEvent(
      title: "Maternal & Child Health Day",
      description:
          'Talks on antenatal care, nutrition and immunisation, with free baby weighing.',
      date: DateTime(2026, 12, 3),
      time: '9:00 AM',
      location: 'Maternity Wing',
      category: EventCategory.healthTalk,
    ),
    HospitalEvent(
      title: 'Free Eye & Vision Screening',
      description:
          'Get your eyes checked by our ophthalmology team and learn how to protect your sight.',
      date: DateTime(2026, 12, 10),
      time: '9:00 AM',
      location: 'Eye Clinic',
      category: EventCategory.screening,
    ),
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
            child: FadeSlideIn(
              index: 0,
              child: _buildBanner()
            ),
          ), 


          SliverAppBar(
            title: _buildCategoryChips(),
            pinned: true,
          ),


          if(!true) SliverToBoxAdapter(  
            child: _buildFlagShipEvent(),
          ),


          SliverToBoxAdapter(  
            child: _buildEventsView(),
          ),


          const SliverToBoxAdapter(
            child: PageFooter(),
          )
        ],
      ),
    );
  }


  Widget _buildBanner(){
    return Container(  
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade900, 
            Colors.amber
          ], 
          
        )
      ),
      child: Column(  
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        mainAxisSize: .min, 
        children: [
          
          CustomText(
            'Events & Community Programmes',
            fontSize: fluidInterpolation(context, 30, 50),
            fontWeight: FontWeight.w800,
            height: 1.15,
            textColor: Colors.white,
          ),

          const SizedBox(height: 10),

          CustomText(
            'Join our talks, screenings and workshops, and take charge of your health.',
            fontSize: fluidInterpolation(context, 15, 18),
            height: 1.5,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }



  Widget _buildCategoryChips(){

    final eventCategories = <(String, IconData?, Color, EventCategory?)>[
      ('All', null, Colors.blue.shade900, null), 
      ...EventCategory.values.map((cat) => (cat.label, cat.icon, cat.color, cat))
    ];

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
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: eventCategories.length, 
            itemBuilder: (_, index){
      
              final (label, icon, color, category) = eventCategories[index];
          
              return CustomChip(  
                text: label,
                icon: icon,
                hoverBackgroundColor: color.withAlpha(140),
                selectedBackgroundColor: color,
                isSelected: _selectedIndex == index,
                onPressed: () => setState(() => _selectedIndex = index),
              );
              
            }, 
            separatorBuilder: (_, _) => SizedBox(width: 8,),
          )
        ),
      ),
    );
  }



  Widget _buildFlagShipEvent(){

    return SizedBox.shrink();
  }



  Widget _buildEventsView(){
    
    return SectionContainer(  
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 1100, 
          ),
          child: ResponsiveGrid.builder(  
            mainAxisExtent: 370,
            itemCount: sampleEvents.length,
            itemBuilder: (context, index) => revealAnimationWidget(
              delay: Duration(milliseconds: 200 + index),
              child: EventCard(event: sampleEvents[index],
              )
            ),
          ),
        ),
      ),
    );
  }
}
