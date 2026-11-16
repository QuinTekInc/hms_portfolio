
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_portfolio/bloc/events_bloc.dart';
import 'package:hms_portfolio/components/alert.dart';
import 'package:hms_portfolio/components/animations.dart';
import 'package:hms_portfolio/components/button.dart';
import 'package:hms_portfolio/components/card_containers.dart';
import 'package:hms_portfolio/components/event_cards.dart';
import 'package:hms_portfolio/components/page_footer.dart';
import 'package:hms_portfolio/components/page_header.dart';
import 'package:hms_portfolio/components/placeholders.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'package:hms_portfolio/components/text.dart';
import 'package:hms_portfolio/models/models.dart';
import 'package:shimmer/shimmer.dart';

class EventsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  int _selectedIndex = 0;

  final List<(String, IconData?, Color, EventCategory?)> eventCategories = [
      ('All', null, Colors.blue.shade900, null), 
      ...EventCategory.values.map(
        (cat) => (cat.label, cat.icon, cat.color, cat))
    ];

  EventsLoaded? _loadedState;

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


          //check when there is a flagship event
          SliverToBoxAdapter(  
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

    return SectionContainer(
      backgroundColor: Colors.grey.shade200,
      minHeight: 35,
      maxHeight: 35,
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
            onPressed: () {
              (context.read<EventsCubit>().state as EventsLoaded).applyFilter(category);
              setState(() => _selectedIndex = index);
            },
          );
          
        }, 
        separatorBuilder: (_, _) => SizedBox(width: 8,),
      ),
    );
  }



  Widget _buildFlagShipEvent(){

    return BlocConsumer<EventsCubit, EventsState>( 
      listener: (_, state){
        if(state is EventsError) {
          showAlertDialog(
            context: context, 
            alertType: AlertType.error,
            contentText: state.message
          );
        }
      },
      builder: (_, state){

        if(state is EventsInitial || state is EventsLoading){
          return Shimmer(
            gradient: LinearGradient(  
              colors: [Colors.grey.shade500, Colors.grey.shade200]
            ),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12)
              ),
            )
          );
        }


        if(state is EventsError){
          return SizedBox.shrink();
        }


        final flagshipEvent = (state as EventsLoaded).flagshipEvent;

        if(flagshipEvent == null || _selectedIndex != 0){
          return SizedBox.shrink();
        }

        return SectionContainer(
          child: FlagshipEventCard(
            hospitalEvent: flagshipEvent,
            onTap: (newValue){},
          ),
        );
      },
    );
  }



  Widget _buildEventsView(){

    return BlocBuilder<EventsCubit, EventsState>( 

      builder: (_, state){
        if(state is EventsInitial || state is EventsLoading){
          return SectionContainer(
            child: Shimmer(
              gradient: LinearGradient(  
                colors: [Colors.grey.shade50, Colors.grey.shade300]
              ),
              child: ResponsiveGrid.builder(  
                itemCount: 5,
                itemBuilder: (_, _) => Container(  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12)
                  ),
                )
              )
            ),
          );
        }


        if(state is EventsError){
          return SizedBox.shrink();
        }

        _loadedState = (state as EventsLoaded);

        final events = _loadedState!.eventsFilter;

        if(events.isEmpty){
          return  PlaceholderMessage(
            title: 'No Events', 
            message: 'All hospital events appear here.', 
            maxWidth: 1100,
          );
        }


        return SectionContainer(  
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 1100, 
              ),
              child: ResponsiveGrid.builder(  
                mainAxisExtent: 370,
                itemCount: events.length,
                itemBuilder: (context, index) => revealAnimationWidget(
                  delay: Duration(milliseconds: 200 + index),
                  child: EventCard(event: events[index],
                  )
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
