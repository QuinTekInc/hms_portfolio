

import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';


String baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://127.0.0.1:8000/website';


const Map<String, String> _headers = {
  'Content-Type': 'application/json'
};


String concat(String other,){  
  return '$baseUrl/$other';
}



Future<http.Response> getRequest({required String endpoint, dynamic body,}) async {

  final url = Uri.parse(concat(endpoint));

  return http.get(
    url, 
    headers: _headers
  );
}


Future<http.Response> postRequest({required String endpoint, required Object body,}) async {

  final url = Uri.parse(concat(endpoint,));


  return await http.post(
    url,
    headers: _headers,
    body: body
  );
}






// class WebSocketService{

//   late WebSocket _websocket;
//   final StreamController<Map<String, dynamic>> _streamController = StreamController<Map<String, dynamic>>.broadcast();

//   Stream get dataStream =>  _streamController.stream;

//   final String consumerEndpoint;
//   final bool Function(Map<String, dynamic>)? streamValidator;

//   WebSocketService({required this.consumerEndpoint, this.streamValidator}){
//     connect();
//   }

//   String _buildUrl(String endpoint){
//     return 'ws://127.0.0.1:8000/$endpoint';
//   }


//   void connect() async {

//     String token = await getAuthorizationToken();

//     final wsURL = Uri.parse(_buildUrl(consumerEndpoint));

//     try{
//       _websocket = WebSocket(wsURL, headers: {'Authorization': 'Token ${token.trim()}'});

//       _websocket.messages.listen(
//         (message) {
//           // Assuming the incoming message is a JSON string
//           final Map<String, dynamic> data =  jsonDecode(message);

//           if(streamValidator != null){

//             if(streamValidator!(data)){
//               _streamController.add(data);
//             }

//           }else{
//             _streamController.add(data);
//           }

//         }, 
//         onError: (error) async  {
//           _streamController.addError(error);
//           await _streamController.close();
//         },

//         onDone: () => _websocket.close()
//       );

//     }catch(error){
//       throw Error();
//     }
//   }


//   void dispose(){
//     _websocket.close();
//     _streamController.close();
//   }

// }

