import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:malappuram/model/client.dart';

class ClientService {
  static const String baseUrl = 'https://apist.alnasiyaerp.com/rest/v1/clients';
  static const String apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJhbm9uIiwKICAgICJpc3MiOiAic3VwYWJhc2UtZGVtbyIsCiAgICAiaWF0IjogMTY0MTc2OTIwMCwKICAgICJleHAiOiAxNzk5NTM1NjAwCn0.dc_X5iR_VP_qT0zsiyj_I_OZ2T9FtRU2BBNWN8Bu4GE';
 
  Future<List<Client>> fetchClients({int page = 1, int limit = 10}) async {
    try {

      final url = Uri.parse('$baseUrl?select=*');
      print('Requesting: $url'); 
      final response = await http.get(url, headers: {'apikey': apiKey});


      if (response.statusCode == 200) {
  
        final List<dynamic> data = json.decode(response.body);
        return data.map((client) => Client.fromJson(client)).toList();
      } else {
        print(response); 
        throw Exception('Failed to load clients: ${response.statusCode}');
      }
    } catch (e) {
     
      throw Exception('Error fetching clients: $e');
    }
  }

  Future<void> addClient(Client client) async {
    try {
      
      print('Client Data: ${jsonEncode(client.toJson())}');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'apikey': apiKey,
          'Content-Type': 'application/json', 
        },

        body: jsonEncode(client), 
      );

      
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        print('Client added successfully');
      } else {
        print('Failed to add client. HTTP Status: ${response.statusCode}');
        print('Error Details: ${response.body}');
        throw Exception('Failed to add client');
      }
    } catch (e) {
      print('Error adding client: $e');
      throw Exception('Failed to add client');
    }
  }
}

