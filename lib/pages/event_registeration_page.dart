
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_portfolio/bloc/events_bloc.dart';
import 'package:hms_portfolio/components/alert.dart';
import 'package:hms_portfolio/components/animations.dart';
import 'package:hms_portfolio/components/button.dart';
import 'package:hms_portfolio/components/card_containers.dart';
import 'package:hms_portfolio/components/constants.dart';
import 'package:hms_portfolio/components/page_footer.dart';
import 'package:hms_portfolio/components/page_header.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'package:hms_portfolio/components/text.dart';
import 'package:hms_portfolio/models/models.dart';


class EventRegisterationPage extends StatefulWidget {
  const new({super.key});

  @override
  State<EventRegisterationPage> createState() => _EventRegisterationPageState();
}

class _EventRegisterationPageState extends State<EventRegisterationPage> {

  late HospitalEvent hospitalEvent;

  final Map<String, dynamic> answers = {};
  List<RegistrationField> registrationFields = [];
  final List<dynamic> controllers = [];

  late bool requiresRegistration;
  bool isSubmittingRegistration = false;

  final registerWidgetKey = GlobalKey();

  @override 
  void initState(){
    super.initState();

    hospitalEvent = context.read<RegistrationCubit>().hospitalEvent;
    requiresRegistration = hospitalEvent.requiresRegistration;

    loadData();
  }

  @override  
  void dispose(){
    super.dispose();
    //todo: implement dispoing fields here.
    controllers.where(
      (controller) => controller is TextEditingController || controller is DropdownController)
      .forEach((controller) => controller.dispose());

    controllers.clear();
    answers.clear();
  }


  void loadData() async {
    await context.read<RegistrationCubit>().fetchRegistrationFields();

    if(context.read<RegistrationCubit>().state is! RegistrationLoaded) return;

    registrationFields = (context.read<RegistrationCubit>().state as  RegistrationLoaded).registrationFields;

    //set up the answers keys map
    _generateControllers();

  }

  void _generateControllers(){

    for(final registrationField in registrationFields){

      //todo: answers map
      answers[registrationField.fieldKey] = '';


      //todo: determine the controller type and add them to the list of controllers.
      switch(registrationField.fieldType){
        case .checkbox:
        case .unknown:
          controllers.add(null);
          break;

        case .select:
          final controller = DropdownController<String>();
          controllers.add(controller);
          break;

        default:
          final controller = TextEditingController();
          controllers.add(controller);
          continue;
      }
    }

  }



  void scrollTo(GlobalKey widgetKey){
    Scrollable.ensureVisible(
      widgetKey.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: PreferredSize(
        preferredSize: .fromHeight(120),
        child: PageHeader(),
      ),

      body: CustomScrollView(
        slivers: [

          SliverToBoxAdapter(  
            child: _buildBanner(),
          ),


          if([EventStatus.pending].contains(hospitalEvent.status)) SliverToBoxAdapter(  
            child: _buildCountDown()
          ),


          SliverToBoxAdapter(  
            child: _buildContent(),
          ),


          if(requiresRegistration) SliverToBoxAdapter(
            child: BlocBuilder<RegistrationCubit, RegistrationState>( 
              builder: (_, state){
            
                if(state is! RegistrationLoaded) return SizedBox.shrink();
            
                return revealAnimationWidget(
                  child: _buildRegistrationFields()
                );
              },
            ),
          ),

          const SliverToBoxAdapter(  
            child: PageFooter(),
          )

        ],
      )
    );
  }

  Widget _buildBanner(){

    Widget bannerView;

    if(ResponsiveUtil.isDesktop(context)){
      bannerView = Row(
        children: [
          Expanded(  
            child: Column( 
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              spacing: 8, 
              children: [

                Wrap( 
                  spacing: 8,  
                  children: [

                    if(hospitalEvent.isFlagshipEvent) Pill(
                      background: Colors.amber,
                      foreground: Colors.blue.shade900,
                      icon: Icons.event,
                      label: 'FlagShip Event',
                    ),


                    Pill(  
                      background: Colors.amber,
                      foreground: Colors.blue.shade900,
                      icon: Icons.event_note,
                      label: hospitalEvent.category.label,
                    )
                  ],
                ),

                HeaderText.withResponsiveSize(
                  hospitalEvent.name, 
                  textColor: Colors.white,
                ), 


                CustomText(
                  'THEME', 
                  fontWeight: .w800, 
                  textColor: Colors.amber,
                ), 

                CustomText(  
                  hospitalEvent.description, 
                  textColor: Colors.white.withAlpha(150),
                  fontSize: 16,
                ),


                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Pill(  
                        background: Colors.blue.shade900.withAlpha(120),
                        foreground: Colors.amber,
                        label: formatDate(hospitalEvent.startDate),
                        icon: Icons.calendar_month,
                        borderColor: Colors.white.withAlpha(180),
                      ),
                  
                      Pill(  
                        background: Colors.blue.shade900.withAlpha(120),
                        foreground: Colors.amber,
                        label: '',
                        icon: Icons.timer_outlined,
                        borderColor: Colors.white.withAlpha(180),
                      ),



                      Pill(  
                        background: Colors.blue.shade900,
                        foreground: Colors.white.withAlpha(180),
                        label: hospitalEvent.location,
                        icon: Icons.location_on,
                        borderColor: Colors.white.withAlpha(180),
                      ),
                      
                    ],
                  ),
                ),


                if(hospitalEvent.requiresRegistration) ...[
                  const SizedBox(  
                    height: 12,
                  ),

                  CustomText(
                    'Click on the button below to register for this event', 
                    textColor: Colors.white.withAlpha(180), 
                    fontSize: 12,
                  ),

                  FilledButton(  
                    onPressed: () => scrollTo(registerWidgetKey),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue.shade900, 
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24)
                    ),
                    child: CustomText(
                      'Signup for event', 
                      textColor: Colors.white,
                      fontSize: 15,
                    ),
                  )
                ]

              ],
            ),
          ), 


          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              hospitalEvent.coverImage!, 
              fit: BoxFit.cover,
              height: 350,
            ),
          )
        ],
      );
    }else{
      bannerView = Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top:Radius.circular(12)),
            child: Image.network(
              hospitalEvent.coverImage!, 
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
            ),
          )
        ],
      );
    }
  
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        children: [
      
          Container( 
            width: double.infinity, 
            height: double.infinity,
            alignment: Alignment.center, 
            decoration: BoxDecoration(  
              gradient: LinearGradient(  
                colors: [Colors.blue.shade900, Colors.blue.shade600, Colors.amber, Colors.amber.shade700], 
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              )
            ),
          ),
      
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withAlpha(70),
          ), 
      
      
          Align(
            alignment: ResponsiveUtil.sizeBasedValue<Alignment>( 
              context: context, 
              desktopValue: Alignment.center,
              mobileValue: Alignment.topLeft,
            ),
            child: SectionContainer(
              child: bannerView,
            ),
          )
        ],
      ),
    );
  }


  Widget _buildCountDown(){

    return SectionContainer(
      backgroundColor: Colors.blue.shade900,
      child: CountDownWidget(eventDate: hospitalEvent.startDate),
    );
  }



  Widget _buildContent(){

    return SectionContainer(
      minHeight: MediaQuery.of(context).size.height * 0.1,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
        
            HeaderText.withResponsiveSize('Event Details'),
        
            //helloworld
            CustomText('Hello World this is something about the event motherfucker')
        
          ],
        ),
      ),
    );
  }


  Widget _buildRegistrationFields(){


    final detailSection = Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      spacing: 8,
      children: [
        Pill.sectionTitle(
          label: 'Join us', 
          color: Colors.blue.shade900,
        ), 
        
        HeaderText.withResponsiveSize(
          'Register for this event',
          textColor: Colors.blue.shade900,
        ),

        CustomText(
          'By completing and submitting this form, you are taking the first step '
          'towards being part of this exciting event! We look forward to receiving '
          'your registration and learning about your interest in participating. '
          'All submissions will be carefully reviewed by the Secretariat, and '
          'those who are successfully selected will receive a confirmation email '
          'with further details. We appreciate your interest and look forward to '
          'the possibility of welcoming you!', 
          padding: EdgeInsets.zero,
          textColor: Colors.black.withAlpha(180),
          fontSize: 16,
          height: 1.5,
        )
      ],
    );


    final registrationFormCard = Card(
      color: Colors.white,  
      child:  Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16, 
          vertical: 32
        ),
        child: Column(  
          mainAxisAlignment: .center,
          crossAxisAlignment: .start, 
          mainAxisSize: .min,
          spacing: 8,
          children: [
            
            for(int i = 0; i < registrationFields.length; i++) 
              _buildRegistrationFieldWidget(registrationFields[i], i), 
        
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _submitRegistration, 
                style: ElevatedButton.styleFrom(  
                  backgroundColor: Colors.blue.shade900, 
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
                child: isSubmittingRegistration ?
                  SizedBox(
                    height: 25,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ) 
                : 
                  CustomText(
                    'Register', 
                    textColor: Colors.white,
                    fontSize: 16,
                  )
              ),
            )
          ],
        ),
      ),
    );

    return SectionContainer(
      key: registerWidgetKey,
      backgroundColor: Colors.amber.withAlpha(220),
      child: ResponsiveUtil.sizeBasedWidget(
        mobileView: Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            detailSection, 
            registrationFormCard
          ],
        ), 
        desktopView: Row(  
          crossAxisAlignment: .start,
          spacing: 12,
          children: [
            Expanded(child: detailSection,),
            Expanded(child: registrationFormCard)
          ],
        )
      )
    );
  }



  Widget _buildRegistrationFieldWidget(RegistrationField registrationField, int fieldIndex) {
  
    final key = registrationField.fieldKey;
    final label = registrationField.label;

    Widget fieldWidget;

    switch (registrationField.fieldType) {

      case .unknown:
        return SizedBox.shrink();

      case .select:
        fieldWidget = CustomDropdownButton<String>(
          controller: (controllers[fieldIndex] as DropdownController<String>), 
          hint: label,
          items: registrationField.options!, 
          onChanged: (newValue) => setState(() => answers[key] = newValue ?? '')
        );
        break;

      case .checkbox:
        fieldWidget = CustomCheckBox(
          value: answers[key] == true,
          text: label,
          onChanged: (v) => setState(() => answers[key] = v),
        );
        break;

      default: // text, email, phone, number, date
        fieldWidget = CustomTextField(
          controller: (controllers[fieldIndex] as TextEditingController),
          hintText: label,
          keyboardType: registrationField.fieldType == .number ? TextInputType.number : TextInputType.text,
          onChanged: (v) => answers[key] = v,
        );
        break;
    }


    return Column(  
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      spacing: 3,
      children: [

        if(registrationField.fieldType != .checkbox) CustomText(
          '$label ${registrationField.isRequired ? '*' : ''}', 
          fontWeight: FontWeight.w600,
          textColor: Colors.black54,
          fontSize: 15,
        ),

        fieldWidget
      ],
    );
  }


  void _submitRegistration() async {

    //exit quickly from the function when transmission is already in progress.
    if(isSubmittingRegistration) return;

    setState(() => isSubmittingRegistration = true);

    await Future.delayed(Duration(seconds: 5), (){});

    for(int i = 0; i < registrationFields.length; i++){

      final field = registrationFields[i];

      final answer = answers[field.fieldKey];

      if(!field.isRequired) continue;

      if((answer is String && answer.isEmpty) || (answer is bool && answer == false) ){

        await showAlertDialog(
          context: context, 
          alertType: AlertType.warning,
          title: 'Field is Required',
          contentText: "'${field.label}' is a required field. Please provide data for it."
        );

        setState(() => isSubmittingRegistration = false);
        return;
      }

    }


    try{

      await context.read<RegistrationCubit>().submitRegistration(
        email: answers['email'], 
        answers: answers
      );

      setState(() => isSubmittingRegistration = false);

    }catch(ex){

      setState(() => isSubmittingRegistration = false);

      showAlertDialog(
        context: context, 
        alertType: AlertType.error,
        title: 'Registration Error',
        contentText: 'Could not submit registration data. Please try again.'
      );


    }

    debugPrint(answers.toString());
  }
}




class CountDownWidget extends StatefulWidget {

  final DateTime eventDate;

  const new({super.key, required this.eventDate});

  @override
  State<CountDownWidget> createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {

  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update());
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _update() {
    final diff = widget.eventDate.difference(DateTime.now());
    setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
  }


  @override
  Widget build(BuildContext context) {

    final remainingItems = [
      ('Days', _remaining.inDays), 
      ('Hours', _remaining.inHours % 24), 
      ('Minutes', _remaining.inMinutes % 60),
      ('Seconds', _remaining.inSeconds & 60)
    ];



    return ResponsiveUtil.sizeBasedWidget(
      mobileView: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          HeaderText(
            'The countdown is On',
            textColor: Colors.white,
          ),

          const SizedBox(height: 3,),

          CustomText( 
            'Anticipate this event.', 
            textColor: Colors.white.withAlpha(150),
            fontSize: 15,
            height: 1.5,
          ),


          const SizedBox(height: 12,),

          ResponsiveGrid.builder(
            itemCount: remainingItems.length,
            minItemWidth: 120,
            itemBuilder: (context, index){
          
              final (title, remaining) = remainingItems[index];
          
              return _buildTimerCell(title: title, remaining:  remaining);
            },
          )
        ],
      ), 

      desktopView: Row(
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              spacing: 3,
              children: [
                HeaderText(
                  'The countdown is on', 
                  textColor: Colors.white,
                ),


                CustomText( 
                  'Anticipate this event.', 
                  textColor: Colors.white.withAlpha(150),
                  fontSize: 15,
                  height: 1.5,
                )

              ],
            )
          ), 
          Spacer(),
          Expanded(
            flex: 2,
            child: ResponsiveGrid.builder(
              itemCount: remainingItems.length,
              minItemWidth: 120,

              itemBuilder: (context, index){
            
                final (title, remaining) = remainingItems[index];
            
                return _buildTimerCell(title: title, remaining:  remaining);
              },
            ),
          )
        ],
      )
    );
  }



  Widget _buildTimerCell({required String title, required int remaining}){
    return Container(  
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(  
        color: Colors.white.withAlpha(40),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withAlpha(120),
          width: 1.5
        )
      ),
      child: Column(  
        children: [
          HeaderText(  
            remaining.toString().padLeft(2, '0'), 
            textColor: Colors.white,
          ), 

          CustomText(
            title, 
            textColor: Colors.white.withAlpha(150),
          )
        ],
      ),
    );
  }
}