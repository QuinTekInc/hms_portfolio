
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

    }

  }


  static Future<dynamic> getEvents() async {

    final response = await serverConnector.getRequest(endpoint: '');

    if(response.statusCode != 200){

    }

  }


  static Future<void> subscribeNewsLetter(String email) async{
    await Future.delayed(Duration(seconds: 3), (){});
  }

}