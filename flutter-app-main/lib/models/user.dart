class UserBasic {
  String name;
  String email;
  // String city;
  // String address;
  String phone;

  UserBasic(this.name, this.email, this.phone);

  Map<String, dynamic> get map {
    return {
      "name": name,
      "email": email,
      //"city": city,
      //"address": address,
      "phone": phone,
    };
  }

  bool operator ==(o) =>
      o is UserBasic &&
      name == o.name &&
      email == o.email &&
      //city == o.city &&
      // address == o.address &&
      phone == o.phone;
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      // city.hashCode ^
      //address.hashCode ^
      phone.hashCode;
}

class UserAddress {
  String phone;
  String name;
  String lane1;
  String lane2;
  String town;
  String pincode;

  UserAddress(
      this.name, this.phone, this.lane1, this.lane2, this.town, this.pincode);

  UserAddress.fromMap(Map<String, dynamic> addr)
      : name = addr['name'] ?? '',
        phone = addr['phone'] ?? '',
        lane1 = addr['lane1'] ?? '',
        lane2 = addr['lane2'] ?? '',
        town = addr['town'] ?? '',
        pincode = addr['pincode'] ?? '';

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = name ?? '';
    map['lane1'] = lane1 ?? '';
    map['lane2'] = lane2 ?? '';
    map['town'] = town ?? '';
    map['pincode'] = pincode ?? '';
    map['phone'] = phone ?? '';

    return map;
  }
}
