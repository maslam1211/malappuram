
import 'package:flutter/material.dart';
import 'package:malappuram/model/client.dart';
import 'package:malappuram/viewmodels/client_models.dart';
import 'package:malappuram/views/clients/client_form.dart';
import 'package:provider/provider.dart';

class ClientList extends StatefulWidget {
  const ClientList({Key? key}) : super(key: key);

  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientViewModelProvider>().fetchClients();
    });
  }

  int currentPage = 0;
  static const int itemsPerPage = 5;
  String searchQuery = '';

  List<Client> get filteredData {
    if (searchQuery.isEmpty) {
      return Provider.of<ClientViewModelProvider>(context).clients;
    }
    return Provider.of<ClientViewModelProvider>(context)
        .clients
        .where((item) =>
            item.clientName!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  List<Client> get currentItems {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredData.sublist(
      startIndex,
      endIndex > filteredData.length ? filteredData.length : endIndex,
    );
  }

  int get totalPages => (filteredData.length / itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paginated List'),
      ),
      body: currentItems.isEmpty
          ? Center(child: Text('No clients available.'))
          : context.read<ClientViewModelProvider>().errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                      context.read<ClientViewModelProvider>().errorMessage))
              : context.read<ClientViewModelProvider>().isLoading &&
                      context.read<ClientViewModelProvider>().clients.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.only(left: 32.0, right: 132),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 300,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Search by Client Name',
                                      border: OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.search),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        searchQuery = value;
                                        currentPage = 0;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const ClientForm()),
                                  );
                                },
                                style: ButtonStyle(
                                    foregroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.red),
                                    shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero,
                                            side: BorderSide(
                                                color: Colors.red)))),
                                child: Text(
                                  'Add New Clients',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                          filteredData.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No clients found.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : DataTable(
                                  // ignore: deprecated_member_use
                                  dataRowHeight: 100,
                                  columns: const [
                                    DataColumn(
                                        label: Text(
                                      'Logo',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Client ID',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Phone',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Email',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Location',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Address',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Status',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )),
                                  ],
                                  rows: currentItems.map((client) {
                                    print("client.status ${client.status}");
                                    return DataRow(cells: [
                                      DataCell(CircleAvatar()),
                                      DataCell(Text(client.clientId ?? "")),
                                      DataCell(Text(client.clientName ?? "")),
                                      DataCell(Text(client.phoneNumber ?? "")),
                                      DataCell(Text(client.emailAddress ?? "")),
                                      DataCell(Text(client.location ?? "")),
                                      DataCell(Text(client.address ?? "")),
                                      DataCell(Container(
                                          width: 70,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: client.status == "Active"
                                                ? Colors.green
                                                : Colors.red,
                                            border: Border.all(),
                                          ),
                                          child: Center(
                                            child: Text(
                                                client.status == "Active"
                                                    ? "Active"
                                                    : "Inactive"),
                                          ))),
                                    ]);
                                  }).toList(),
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: currentPage > 0
                                    ? () {
                                        setState(() {
                                          currentPage--;
                                        });
                                      }
                                    : null,
                                child: const Text('Previous'),
                              ),
                              Text('Page ${currentPage + 1} of $totalPages'),
                              TextButton(
                                onPressed: currentPage < totalPages - 1
                                    ? () {
                                        setState(() {
                                          currentPage++;
                                        });
                                      }
                                    : null,
                                child: const Text('Next'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => const ClientForm()),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
