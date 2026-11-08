
import 'package:flutter/material.dart';
import 'package:hms_portfolio/components/animations.dart';
import 'package:hms_portfolio/components/card_containers.dart';
import 'package:hms_portfolio/components/constants.dart';
import 'package:hms_portfolio/components/page_footer.dart';
import 'package:hms_portfolio/components/page_header.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'package:hms_portfolio/components/shared_functions.dart';
import 'package:hms_portfolio/components/text.dart';


const Color _ink = Color(0xFF0D2A4A);
const Color _muted = Color(0xFF5B7480);
const Color _surface = Color(0xFFF4F8FB);


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



          SliverToBoxAdapter(  
            child: SectionContainer(
              child: Center(
                child: ConstrainedBox(
                  constraints: const .new(  
                    maxWidth: 1100
                  ),
                  child: const  _CallToAction()
                )
              ),
            ),
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
      height: MediaQuery.of(context).size.height * 0.6,
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
            Colors.blue.shade900.withAlpha(60), 
            BlendMode.darken
          )
        )
      ),
      child: Center(  
        child: ConstrainedBox(
          constraints: .new( 
            maxWidth: ResponsiveUtil.sizeBasedValue<double>( 
              context: context,
              desktopValue: 1100, 
              mobileValue: double.infinity
            )
          ),
          child: Column(
            mainAxisAlignment: .start, 
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            spacing: ResponsiveUtil.isDesktop(context) ? 12 : 8,
            children: [

              revealAnimationWidget(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withAlpha(35),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.amber.withAlpha(140)),
                  ),
                  child: const Text(
                    'OUR SERVICES',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.amber,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              revealAnimationWidget(
                delay: const Duration(milliseconds: 120),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Text(
                    'Complete care, from check-ups to complex treatment.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: fluidInterpolation(context, 30, 52),
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
      
            ]
          ),
        )
      )
    );
  }


  Widget _buildGeneralServices(BuildContext context){

    final gridViewChildren = generalServices.map((serviceItem) => 
      _GeneralItem(name: serviceItem)).toList();
    

    return SectionContainer(
      backgroundColor: Colors.grey.shade200,
      child: Column(  
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        mainAxisSize: .min,
        children: [

          _SectionTitle(  
            eyebrow: 'Everyday Care',
            title: 'General Services',
            subtitle: 'Routine and preventive care for you and your family, available throughout the week.',
          ),
      
          const SizedBox(  
            height: 8,
          ),


          Center(
            child: ConstrainedBox(
              constraints: const .new(
                maxWidth: 1100
              ),
              child: ResponsiveGrid.builder( 
                mainAxisExtent: 55,
                itemCount: gridViewChildren.length,
                itemBuilder: (_, index) => gridViewChildren[index]
              ),
            ),
          )
      
        ],
      ),
    );
  }


  Widget _buildSpecializedServices(BuildContext context){


    final gridViewChidren = specialServicesList.map((serviceItem){
      final (text, imagePath) = serviceItem;
      return _ServiceTile(  
        text: text,
        imagePath: imagePath,
      );

    }).toList();

    return SectionContainer(
      child: Column(  
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [

          _SectionTitle(  
            eyebrow: 'Expert Care',
            title: 'Specialized Services',
            subtitle: 'Led by experienced specialists using equipment for more complex conditions',
            accentRed: true,
          ),

      
          const SizedBox(height: 8,),
      
          Center(

            child: ConstrainedBox(
              constraints: BoxConstraints(  
                maxWidth: 1100
              ),
              child: ResponsiveGrid.builder( 
                mainAxisExtent: 250, 
                itemCount: gridViewChidren.length,
                itemBuilder: (context, index) => revealAnimationWidget(child: gridViewChidren[index]),
              ),
            ),
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







//==========================================================================
//SECTION TITLE
//==========================================================================
class _SectionTitle extends StatelessWidget {

  final String eyebrow;
  final String title;
  final String? subtitle;
  final bool accentRed;

  const _SectionTitle({
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.accentRed = false,
  });

  

  @override
  Widget build(BuildContext context) {
    return revealAnimationWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 4,
                decoration: BoxDecoration(
                  color: accentRed ? Colors.red.shade700 : Colors.amber,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                eyebrow.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: accentRed ? Colors.red.shade700 : Colors.blue.shade900,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fluidInterpolation(context, 26, 36),
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: _ink,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: CustomText(
                subtitle!,
                height: 1.55,
                textColor: _muted, 
                fontSize: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}


//==============================================================================
//GENERAL SERVICES ITEM
//==============================================================================
class _GeneralItem extends StatefulWidget {
  const _GeneralItem({required this.name});

  final String name;

  @override
  State<_GeneralItem> createState() => _GeneralItemState();
}

class _GeneralItemState extends State<_GeneralItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hover ? -3 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _hover ? Colors.white : _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hover ? Colors.blue.shade900 : const Color(0xFFE3ECEF),
            width: _hover ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade900.withAlpha(_hover ? 34 : 0),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _hover ? Colors.amber : Colors.blue.shade900,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                size: 14,
                color: _hover ? Colors.blue.shade900 : Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  color: _ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _CallToAction extends StatelessWidget {

  const _CallToAction({super.key});

  @override
  Widget build(BuildContext context) {
    return revealAnimationWidget(
      child: Container(
        padding: EdgeInsets.all(fluidInterpolation(context, 24, 40)),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.blue.shade700]),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 20,
          spacing: 24,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Not sure which service you need?',
                    style: TextStyle(
                      fontSize: fluidInterpolation(context, 22, 30),
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Book an appointment and our team will guide you to the right department.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.white.withAlpha(210),
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => SharedFunctions.handleOpenBookAppointment(context),
              icon: const Icon(Icons.calendar_month_rounded),
              label: const Text('Book an Appointment'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.blue.shade900,
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}