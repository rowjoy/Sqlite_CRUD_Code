class CustomerModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;

  CustomerModel({this.id, this.firstName, this.lastName, this.email});

  factory CustomerModel.fromMap(Map<String, dynamic> data) => CustomerModel(
      id: data["id"],
      firstName: data["first_name"],
      lastName: data["last_name"],
      email: data["email"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email
      };
}
