
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hms_portfolio/bloc/appointment_bloc.dart';
import 'package:hms_portfolio/components/alert.dart';
import 'package:hms_portfolio/components/button.dart';
import 'package:hms_portfolio/components/responsive_util.dart';
import 'package:hms_portfolio/components/text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookAppointPage extends StatefulWidget {
  const new({super.key});

  @override
  State<BookAppointPage> createState() => _BookAppointPageState();
}

class _BookAppointPageState extends State<BookAppointPage> {


  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _departmentController = DropdownController();
  final _notesController = TextEditingController();
  final _dateController = DatePickerController();


  void consumerFunc(BuildContext context, state){

    if(state is AppointmentLoading){
      showLoadingDialog(context: context);
    }

    if(state is AppointmentError){

      Navigator.pop(context);

      showAlertDialog(
        context: context, 
        alertType: AlertType.error,
        title: 'Error Submitting Request',
        contentText: state.message
      );

      return;
    }


    if(state is AppointmentSubmitted){
      Navigator.pop(context);
      showAlertDialog(  
        context: context,
        alertType: AlertType.success, 
        title: 'Request Submitted Successfully',
        contentText: 'Your appointment request has been successfully submitted.'
                    '\nAn appointment acknowledgement has been sent to your email.'
                    '\n\nThe appointment team will review and confirm your booking within'
                    '1 - 2 working days.\n'
                    'A follow-up email with the confirmed appointment details will be sent you.', 
        
      );
      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentCubit, AppointmentState>(
      listener: consumerFunc,
      
      child: Padding(
        padding: const EdgeInsets.symmetric(  
          horizontal: 36, 
          vertical: 24
        ),
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
      
                Icon(
                  CupertinoIcons.book, 
                  color: Colors.blue.shade900,
                  size: 30,
                ),
      
                HeaderText.withResponsiveSize(  
                  'Book Appointment',
                  textColor: Colors.blue.shade900
                ),
      
                Spacer(), 
      
                IconButton(  
                  icon: Icon(Icons.close, fontWeight: FontWeight.bold, color: Colors.red.shade700, size: 28,),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ), 
      
            CustomText( 
              'Enter your details in the fields below to book an appointment.', 
              padding: EdgeInsets.zero,
            ),
      
      
            const SizedBox(height: 12,),
        
      
            Expanded(  
              child: SingleChildScrollView(  
                child: Column(
                  children: [
                    _buildContent(),
      
                    SizedBox(height: 50,),
      
                    RichText(
                      text: TextSpan(  
                        text: 'Please double-check your contact details.',
                        style: TextStyle(  
                          color: Colors.blue.shade900,
                          fontFamily: 'Poppins', 
                          fontSize: 14, 
                          fontWeight: FontWeight.w600
                        ),
                        children: [
                          TextSpan(  
                            text: ' Enter a valid email address and phone number so we can '
                                  'confirm your appointment, send reminders, and reach you if your doctor\'s schedule changes. '
                                  'Incorrect details may mean you miss important updates about your visit.',
                            style: TextStyle( 
                              color: Colors.black54, 
                              fontWeight: .normal
                            )
                          )
                        ]
                      ),
                    )
                  ],
                ),
              ),
            ), 
      
      
            const SizedBox(height: 12,),
      
      
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(  
                onPressed: _handlePlaceAppointment,
                style: ElevatedButton.styleFrom( 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ), 
                  backgroundColor: Colors.blue.shade900
                ),
                child: CustomText(
                  'Make Appointment', 
                  textColor: Colors.white,
                ),
              ),
            )
        
          ],
        ),
      ),
    );
  }


  Widget _buildContent(){

    final nameField = CustomTextField(  
      controller: _nameController,
      hintText: 'Full Name',
      leadingIcon: CupertinoIcons.person,
      margin: EdgeInsets.zero,
      onChanged: (newValue){},
    );

    final phoneField = CustomTextField(
      controller: _phoneNumberController,
      hintText: 'Phone Number',
      leadingIcon: Icons.phone,
      margin: EdgeInsets.zero,
      onChanged: (newValue){},
    );


    final emailField = CustomTextField(  
      controller: _emailController,
      hintText: 'Email',
      leadingIcon: Icons.alternate_email,
      margin: EdgeInsets.zero,
      onChanged: (newValue){},
    );


    final departmentField = CustomDropdownButton(  
      controller: _departmentController,
      items: List<String>.generate(10, (i) => 'Department $i'),
      hint: 'Select Department',
      onChanged: (newValue){},
    );


    final datePicker =  DatePickerField(  
      controller: _dateController,
      firstDate: DateTime.now(), 
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      hintText: 'Select Date',
    );


    final noteField = CustomTextArea(
      controller: _notesController,
      hintText: 'Additional Notes Optional',
    );




    List<dynamic> viewStructure;

    if(ResponsiveUtil.isDesktop(context)){
      viewStructure = [
        [nameField, phoneField],
        [emailField, departmentField],
        datePicker, 
        noteField
      ];
    }else{
      viewStructure = [
        nameField, 
        phoneField, 
        emailField, 
        departmentField, 
        datePicker, 
        noteField,
      ];
    }


    return Column(  
      mainAxisAlignment: .start,
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      spacing: 12,
      children: viewStructure.map((item){

        if(item is List && item.length > 1){
          return Row(  
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12,
            children: item.map((w) => Expanded(child: w,)).toList()
          );
        }
        return item as Widget;

      }).toList(),
    );

  }



  void _handlePlaceAppointment() {

    String name = _nameController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();
    String email = _emailController.text.trim();
    String department = _departmentController.value;
    DateTime appointmentDate = _dateController.value!;
    String notes = _notesController.text;


    context.read<AppointmentCubit>().makeAppointment(
      name: name, 
      phoneNumber: phoneNumber, 
      email: email, 
      department: department, 
      appointmentDate: appointmentDate, 
      notes: notes
    );

  }
}




