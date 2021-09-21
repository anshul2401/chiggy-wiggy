class CustomerModel {
  int id;
  String email;
  String firstName;
  String lastName;
  String userName;
  CustomerModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    return data;
  }
}

List<CustomerModel> customerFromJson(dynamic str) =>
    List<CustomerModel>.from((str).map((x) => CustomerModel.fromJson(x)));
