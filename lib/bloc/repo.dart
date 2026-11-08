
import  'package:hms_portfolio/components/server_connector.dart' as serverConnector;
import 'dart:convert';
import 'package:hms_portfolio/models/models.dart';

class Repository{

  static Future<void> bookAppointment(Map<String, dynamic> appointmentBody) async {
    final response = await serverConnector.postRequest(
      endpoint: '',
      body: jsonEncode(appointmentBody)
    );


    if(response.statusCode != 200){
      throw Exception("Could not send appoinment request: ${response.statusCode}");
    }
  }  

  static Future<List<NewsArticle>> getNews() async {

    final response = await serverConnector.getRequest(endpoint: 'gallery-images/');

    if(response.statusCode != 200){
      throw Exception('An error occurred: ${response.statusCode}');
    }

    final responseBody = List<Map<String, dynamic>>.from(jsonDecode(response.body));

    return responseBody.map((jsonMap) => NewsArticle.fromJson(jsonMap)).toList();

  }

  static Future<dynamic> getGalleryImages() async {

    final response = await serverConnector.getRequest(endpoint: '');

    if(response.statusCode != 200){
      throw Exception("Could not fetch gallery: ${response.statusCode}");
    }

  }


  static Future<List<HospitalEvent>> getEvents() async {

    final response = await serverConnector.getRequest(endpoint: '/events/');

    if(response.statusCode != 200){
      throw Exception("Could not fetch events: ${response.statusCode}");
    }

    final responseBody = List<Map<String, dynamic>>.from(jsonDecode(response.body));

    return responseBody.map(
      (jsonMap) => HospitalEvent.fromJson(jsonMap)).toList();
  }


  static Future<void> subscribeNewsLetter(String email) async {

    final response = await serverConnector.postRequest(
      endpoint: 'newsletter-subscribe/', 
      body: jsonEncode({'email': email})
    );

    if(response.statusCode != 200){
      throw Exception("Could not subcribe to newsletter: ${response.statusCode}");
    }

    await Future.delayed(Duration(seconds: 3), (){});
  }


  static Future<dynamic> fetchHospitalServices() async {
    final response = await serverConnector.getRequest(
      endpoint: 'hospital-services/');

    if(response.statusCode != 200){
      throw Exception("Could not fetch hospital services: ${response.statusCode}");
    }


    final responseBody = jsonDecode(response.body);

    return responseBody;
  }

}