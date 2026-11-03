
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hms_portfolio/components/animations.dart';
import 'package:hms_portfolio/components/card_containers.dart';
import 'package:hms_portfolio/components/constants.dart';
import 'package:hms_portfolio/components/news_card.dart';
import 'package:hms_portfolio/components/page_footer.dart';
import 'package:hms_portfolio/components/page_header.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'package:hms_portfolio/components/slideshow.dart';
import 'package:hms_portfolio/components/text.dart';

class Homepage extends StatelessWidget {

  Homepage({super.key});


  final slideShowItems = [
    BannerSlide(  
      title: 'Welcome to Methodist Hospital Aburaso', 
      subtitle: 'Compassionate healthcare for you and your family',
      image: 'assets/img/pediatrics.jpg'
    ),

    BannerSlide(  
      title: 'Everything your health needs in one place.', 
      subtitle: 'General and specialised services delivered by a dedicated team',
      image: 'assets/img/doctor.jpg'
    ), 

    BannerSlide(  
      title: 'Quality care you can trust', 
      subtitle: 'Professional, affordable and faith inspired compassionate healthcare',
      image: 'assets/img/surgery.jpg'
    )

  ];

  final missionVisionItems = [
    (
      Icons.electric_bolt_outlined, 
      "Mission", 
      "Our mission is to make people whole again."
    ), 
    (
      Icons.remove_red_eye_outlined, 
      "Vision", 
      "The vision is to provide impactful and holistic healthcare to people."
    ),
    ( 
      Icons.handshake_outlined, 
      "Core Values", 
      ['Compassion','Teamwork', 'Fainess', 'Integrity', 'Excellence'].map((cvalue) => '\u2022 $cvalue').join("\n")
    )
  ];


  final chooseUsItems = [
    (
      Icons.electric_bolt,
      'Comfortable Care',
      'Our facility has all the comfort you need to get healed in the shortest possible time'
    ),
    (
      Icons.electric_bolt, 
      'Specialist Consultation', 
      'Specialists consultation services that meets a client\'s needs are provided'
    ), 
    (  
      Icons.electric_bolt, 
      'Highest Quality', 
      'Quality healthcare is always ensured with no compromises made'
    )
  ];



  final forPatientItems = [
    (
      CupertinoIcons.calendar, 
      'Streamlined Scheduling', 
      'Book appointments onle with your preferred specialist'
    ), 
    (
      Icons.emergency,
      '24/7 Emergency Care',
      'The emergency unit is always open: walk or arrive by ambulance for immediate critical care.'
    ), 
    (
      Icons.credit_card, 
      'NHIS & Insurance',
      'We accept the National Health Insurance Scheme and work with major private insurance firms for seamless billing.'
    )
  ];



  final List<Map<String, String>> testimonials = [
   {
      'name': 'Ama Boateng',
      'testimony': 'The nurses were kind and attentive from the moment I arrived. '
          'I always knew what was happening and felt well looked after.',
    },
    
    {
      'name': 'Kwame Mensah',
      'testimony': 'Booking my appointment was simple, and I was seen on time. '
          'The doctor took the time to explain everything clearly.',
    },

    {
      'name': 'Efua Owusu',
      'testimony': 'The whole team treated my family with patience and respect '
          'during a stressful time. We are very grateful.',
    },
    {
      'name': 'Yaw Darko',
      'testimony': 'The facility is clean and well organised, and the staff were '
          'professional at every step of my visit.',
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(150), 
        child: PageHeader(), 
      ),
      body: CustomScrollView(  
        slivers: [

          SliverToBoxAdapter(  
            child: SizedBox(  
              height: MediaQuery.of(context).size.height * 0.5,
              child: BannerSlideShow(
                slides: slideShowItems,
              ),
            ),
          ), 


          SliverToBoxAdapter(
            child: _buildEmergencyBanner(context),
          ),

          SliverToBoxAdapter(  
            child: _buildStatSection()
          ),

          SliverToBoxAdapter(  
            child: _buildMissionAndVission(context),
          ), 

          SliverToBoxAdapter(
            child: _buildAbout(context),
          ), 

          SliverToBoxAdapter(  
            child: _buildAccreditations(),
          ), 

          SliverToBoxAdapter(
            child: _buildHospitalServices(context),
          ), 

          SliverToBoxAdapter(  
            child: _buildForPatients(context)
          ),


          SliverToBoxAdapter(
            child: _buildChooseUs(context)
          ), 


          SliverToBoxAdapter(
            child: _buildNewsSection(context),
          ), 


          SliverToBoxAdapter(  
            child: _buildTestimonial(context),
          ),


          const SliverToBoxAdapter(
            child: WorkingScheduleSection(),
          ),

          const SliverToBoxAdapter(  
            child: PageFooter()
          )
        ],
      )
    );
  }


  Widget _buildEmergencyBanner(BuildContext context){

    return SectionContainer(
      backgroundColor: Colors.red,
      child: Row( 
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        spacing: 12,
        children: [
          Icon(  
            Icons.emergency, 
            color: Colors.white,
          ), 

          CustomText(  
            '24/7 Emergency Call Line: +233 50 236 1709', 
            fontSize: fluidInterpolation(context, 14, 16),
            textColor: Colors.white,
            fontWeight: FontWeight.w700,
          ), 
          
        ],
      ),
    );
  }



  Widget _buildStatSection(){

     const stats = [
      (Icons.groups, '50K+', 'Patients treated'),
      (Icons.medical_information, '120+', 'Specialist doctors'),
      (Icons.apartment, '25', 'Departments'),
      (Icons.workspace_premium, '25 yrs', 'Of excellence'),
    ];

    return SectionContainer(
      backgroundColor: Colors.blue.shade50,
      child: ResponsiveGrid(  
        children: stats.map((item)=> StatContainer(
          icon: item.$1, 
          title: item.$2, 
          detail: item.$3
        )).toList()
      ),
    );
  }

 

  Widget _buildMissionAndVission(BuildContext context) {

    final gridView =  GridView.count(  
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: MediaQuery.of(context).size.width > 720 ? missionVisionItems.length : 1,
        mainAxisExtent: 260,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: missionVisionItems.map((item) => 
          CardContainer(  
            icon: item.$1,
            title: item.$2, 
            detail: item.$3
          )
        ).toList()
      );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, 
        crossAxisAlignment: .center, 
        spacing: 12, 

        children: [

          HeaderText.withResponsiveSize('Mission, Vision And Core Values'), 

          const CustomText( 
            'At the Methodist Hospital Aburaso, specialized healthcare, '
            'education, training research and advocacy services is provided to '
            'Ashanti Region and the nation of Ghana as a whole.',
            fontSize: 14,
          ),


          ResponsiveUtil.sizeBasedWidget(  
            mobileView: gridView, 
            desktopView: Center(  
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: gridView
              ),
            )
          ),
        ]
      ),
    );
  }


  Widget _buildAbout(BuildContext context) {


    final aboutTextWidget = CustomText(
      aboutText,
      textColor: Colors.white,
      fontSize: 14,
    );


    final imageContainer = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/img/surgery.jpg', 
        height: 250,
        fit: BoxFit.fill, 
        width: ResponsiveUtil.sizeBasedValue(  
          context: context, 
          mobileValue: double.infinity, 
          desktopValue: 400.0
        ),
      ),
    );


    return SectionContainer(
      backgroundColor: Colors.blue.shade800,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12,
        children: [

          HeaderText.withResponsiveSize(
            'About MHA', 
            textColor: Colors.white, 
          ),

          // HeaderText(
          //   'Your trusted partner in health and wellness', 
          //   textColor: Colors.white, 
          //   fontSize: 24
          // ),
          
          ResponsiveUtil.sizeBasedWidget(
            mobileView: Column(  
              mainAxisAlignment: .start,
              crossAxisAlignment: .center,
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                imageContainer, 
                aboutTextWidget
              ],
            ),

            desktopView: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: .min,
                spacing: 12,
                children: [
                  imageContainer,

                  Expanded(
                    child: aboutTextWidget
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }


  //affiliations and accreditations
  Widget _buildAccreditations(){

    return SectionContainer(
      backgroundColor: Colors.grey.shade200,  
      child: Column(  
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [

          HeaderText.withResponsiveSize('Our Accreditations'),

          Center(  
            child: ResponsiveGrid.builder(  
              itemCount: accrediationLogs.length,
              itemBuilder: (_, index){
                return Image.asset(  
                  accrediationLogs[index],
                  height: 80,
                  width: 120,
                );
              },
            )
          )

          
        ],
      )
    );
  }


  Widget _buildNewsSection(BuildContext context){

    final gridViewChildren =  List<Widget>.generate(5, (index) => NewsCard(
      article: sampleNews[index], 
      onTap: (neValue){},
    )).toList();


    return  SectionContainer(
      backgroundColor: Colors.blue.shade50,
      child: Column(  
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
      
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              HeaderText.withResponsiveSize('News'),

              Spacer(), 

              TextButton.icon(
                onPressed: (){}, 
                label: CustomText(  
                  'Read More', 
                  textColor: Colors.blue.shade900,
                  fontWeight: FontWeight.w600,
                ),
                icon: Icon(
                  Icons.arrow_forward, 
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.w600,
                ),
                iconAlignment: IconAlignment.end,
              )
            ],
          ), 


          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(  
                maxWidth: 1100
              ),
              child: ResponsiveGrid(
                mainAxisExtent: 400,
                children: gridViewChildren.map((child) => revealAnimationWidget(
                  child: child
                )).toList(),
              ),
            ),
          )
      
        ],
      ),
    );
  }

  Widget _buildHospitalServices(BuildContext context) {


    final viewAllButton = TextButton.icon( 
      onPressed: () => context.go('our-services'), 
      label: CustomText(
        'All Services', 
        textColor: Colors.blue.shade700,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      icon: Icon(
        Icons.arrow_forward_ios, 
        fontWeight: FontWeight.w700, 
        color: Colors.blue.shade700,
      ),
      iconAlignment: IconAlignment.end,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(8),
      ),
    );


    final gridView = GridView.count( 
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: ResponsiveUtil.sizeBasedValue<int>(context: context, desktopValue: 3, mobileValue: 2), 
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
                color: Colors.amber,
                shape: BoxShape.circle, 
              ),
            ),

            Expanded(
              child: CustomText(
                serviceItem,
                fontSize: 14,
              ),
            ),
          ],
         
        )
      ).toList()
    );

    return SectionContainer(
      backgroundColor: Colors.white70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 12,
        children: [

          Row(  
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText.withResponsiveSize('Our Services'), 
              Spacer(), 
              viewAllButton
            ],
          ), 


          CustomText(  
            'We provide a wide range of healthcare services supported by '
            'skilled professionals and state of the art facilities and commitment '
            'to quality health care.\n Some of our services include: ', 
            fontSize: 14,
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

  Widget _buildChooseUs(BuildContext context) {
    final gridViewChildren =  chooseUsItems.map((item){
        return CardContainer(
          iconBackgroundColor: Colors.amber.shade700,
          icon: item.$1, 
          title: item.$2,
          detail: item.$3,
        );
      }).toList();

    return SectionContainer(
      backgroundColor: Colors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, 
        mainAxisAlignment: MainAxisAlignment.start, 
        mainAxisSize: MainAxisSize.min, 
        spacing: 12, 
        children: [

          HeaderText.withResponsiveSize(
            'Why Choose us', 
            textColor: Colors.blue.shade900
          ), 


          ResponsiveGrid(
            mainAxisExtent: 250,
            children: gridViewChildren
          ),
        ]
      ),
    );
  }



  Widget _buildForPatients(BuildContext context){
  
    final gridViewChildren =  forPatientItems.map((item) => CardContainer(  
      icon: item.$1,
      title: item.$2,
      detail: item.$3,
    )).toList();

    return SectionContainer(  
      child: Column( 
        crossAxisAlignment: .center, 
        mainAxisAlignment: .start,
        mainAxisSize: .min,
        spacing: 12,
        children: [

          HeaderText.withResponsiveSize('For Patients'), 


          CustomText( 
            'Navigating healthcare should be simple.'
            'From booking appointments to accessing your medical records,' 
            'we\'ve designed our patient services to put you first.', 
            fontSize: 14,
          ), 

          
          ResponsiveGrid(
            mainAxisExtent: 230,
            children: gridViewChildren,
          )
          

        ],
      )
    );
  }



  // ignore: unused_element
  Widget _buildTestimonial(BuildContext context){

    return SectionContainer(
      child: Column(  
        spacing: 12,
        children: [
          HeaderText.withResponsiveSize('Testimonials'), 

          CustomText(  
            'Testimonies from individuals who have received treatments from Methodist Hospital, Aburaso', 
            textColor: Colors.black54,
            fontSize: fluidInterpolation(context, 18, 16),
          ), 


          ResponsiveGrid(
            mainAxisExtent: 250,
            children: testimonials.map((item){
              return CardContainer(
                icon: CupertinoIcons.person, 
                title: item['name'].toString(), 
                detail: item['testimony'].toString(), 
                crossAxisAlignment: .center,
                mainAxisAlignment: .center,
              );
            }).toList(),
          )
        ],
      )
    );
  }



}





//=================================================================
//WORKING HOURS SECTIONS
//=================================================================
class WorkingScheduleSection extends StatelessWidget {
  const WorkingScheduleSection({super.key});

  static const _schedules = [
    {'day': 'Monday - Friday', 'hours': '8:00 AM - 6:00 PM'},
    {'day': 'Saturday', 'hours': '9:00 AM - 3:00 PM'},
    {'day': 'Sunday', 'hours': 'Closed (emergency only)'},
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width < 600 ? 16.0 : 48.0;

    return Container(
      width: double.infinity,
      color: Colors.blue.shade50,
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(

            children: [

              HeaderText.withResponsiveSize('Working Schedule'),
               // adjust if needed
              const SizedBox(height: 8),

              CustomText('Visit us during these hours.'),
               // adjust if needed
              const SizedBox(height: 32),

              ResponsiveGrid(  
                children: [
                  for(final schedule in _schedules) _ScheduleCard(
                    day: schedule['day']!, 
                    hours: schedule['hours']!
                  )
                ],
              ),
            
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_hospital, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Flexible(
                      child: CustomText('Emergency services are available 24/7.'), // adjust if needed
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.day, required this.hours});
  final String day, hours;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), 
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withValues(alpha: .08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.schedule, color: Colors.blue.shade900, size: 30),
          const SizedBox(height: 12),
          CustomText(day), // adjust if needed
          const SizedBox(height: 6),
          CustomText(hours), // adjust if needed
        ],
      ),
    );
  }
}