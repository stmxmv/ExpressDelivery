class ExpressStation {
  int id;
  String name;
  String address;

  ExpressStation({required this.id, required this.name, required this.address});

  @override
  String toString() {
    return name;
  }
}
