









































































import 'package:flutter/material.dart';
import 'package:malappuram/model/client.dart';
import 'package:malappuram/service/client_service.dart';

class ClientViewModelProvider extends ChangeNotifier {
  final ClientService _clientService = ClientService();
  List<Client> _clients = [];
  List<Client> get clients => _clients;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMoreClients = true; 
  bool get hasMoreClients => _hasMoreClients;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  int _currentPage = 0; 
  final int _limit = 10; 

  
  Future<void> fetchClients({bool isLoadMore = false}) async {
    if (_isLoading || !_hasMoreClients) return;

    if (!isLoadMore) {
      _clients.clear(); 
      _currentPage = 1; 
    }

    _isLoading = true;
    _errorMessage = ''; 
    notifyListeners(); 

    try {
      final List<Client> fetchedClients = await _clientService.fetchClients(
        page: _currentPage,
        limit: _limit,
      );

      if (fetchedClients.isEmpty) {
        _hasMoreClients = false;
      } else {
        _clients.addAll(fetchedClients);
        _currentPage++;
      }

      _isLoading = false;
      notifyListeners(); 
    } catch (e) {
      _errorMessage = 'Failed to load clients: $e';
      _isLoading = false;
      notifyListeners(); 
    }
  }

  
  Future<void> addClient(Client client) async {
    try {
      await _clientService.addClient(client);
      
      await fetchClients();
    } catch (e) {
      _errorMessage = 'Failed to add client: $e';
      print(e); 
      notifyListeners(); 
    }
  }
}
