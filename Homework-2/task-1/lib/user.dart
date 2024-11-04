class User{
  final String name;
  final String phone;
  final String ssn;
  final String address;


  User({required this.name, required this.phone, required this.ssn, required this.address});

  Map<String, Object> toMap(){
    return {
      'name': name,
      'phone': phone,
      'ssn': ssn,
      'address': address,

    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      phone: map['phone'],
      ssn: map['ssn'],
      address: map['address'],
    );
  }

  @override
  String toString() {
    return 'User{ name: $name, phone: $phone, ssn: $ssn, address: $address}';
  }
}