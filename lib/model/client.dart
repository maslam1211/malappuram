class Client {
  String? clientId;
  String? clientName;
  String? phoneNumber;
  String? emailAddress;
  String? location;
  String? address;
  String? status;
  //  bool isActive;

  Client({
    required this.clientId,
    required this.clientName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.location,
    required this.address,
    required this.status,
 
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      clientId: json['client_id'],
      clientName: json['client_name'],
      phoneNumber: json['phone_number'],
      emailAddress: json['email_address'],
      location: json['location'],
      address: json['address'],
      status: json['status'],
   
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'client_name': clientName,
      'phone_number': phoneNumber,
      'email_address': emailAddress,
      'location': location,
      'address': address,
      'status': status,
    };
  }
}
