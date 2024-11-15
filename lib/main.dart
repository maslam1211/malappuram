import 'package:flutter/material.dart';
import 'package:malappuram/views/clients/client_list_page.dart';
import 'package:malappuram/viewmodels/client_models.dart';
import 'package:provider/provider.dart'; 

void main() {
  runApp(
    
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ClientViewModelProvider>(
            create: (context) => ClientViewModelProvider()),
      ],
      
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clients Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ClientList(), 
    );
  }
}
