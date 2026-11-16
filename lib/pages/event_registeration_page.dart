
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_portfolio/bloc/events_bloc.dart';
import 'package:hms_portfolio/components/animations.dart';
import 'package:hms_portfolio/components/button.dart';
import 'package:hms_portfolio/components/card_containers.dart';
import 'package:hms_portfolio/components/constants.dart';
import 'package:hms_portfolio/components/page_footer.dart';
import 'package:hms_portfolio/components/page_header.dart';
import 'package:hms_portfolio/components/text.dart';
import 'package:hms_portfolio/models/models.dart';
import 'package:http/http.dart';


class EventRegisterationPage extends StatefulWidget {
  const new({super.key});

  @override
  State<EventRegisterationPage> createState() => _EventRegisterationPageState();
}

class _EventRegisterationPageState extends State<EventRegisterationPage> {

  final Map<String, dynamic> answers = {};

  List<RegistrationField> registrationFields = [];

  final List<dynamic> controllers = [];

  @override 
  void initState(){
    super.initState();

    loadData();
  }

  @override  
  void dispose(){
    super.dispose();
    //todo: implement dispoing fields here.
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

  void listenerFunc(){
    
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


          SliverToBoxAdapter(
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

    return Container();
  }


  Widget _buildRegistrationFields(){

    final fields = (context.read<RegistrationCubit>().state as RegistrationLoaded).registrationFields;

    return SectionContainer(
      child: Card(
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
          
              Center(
                child: HeaderText.withResponsiveSize('Register for Event')
              ), 
          
              for(final field in fields) _buildRegistrationFieldWidget(field, fields.indexOf(field)), 
          
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _submitRegistration, 
                  style: ElevatedButton.styleFrom(  
                    backgroundColor: Colors.blue.shade900, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    )
                  ),
                  child: CustomText(
                    'Register', 
                    textColor: Colors.white,
                    fontSize: 16,
                  )
                ),
              )
            ],
          ),
        ),
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
          label, 
          fontWeight: FontWeight.normal,
          textColor: Colors.black54,
          fontSize: 15,
        ),

        fieldWidget
      ],
    );
  }




  void _submitRegistration() async {
    debugPrint(answers.toString());
  }
}