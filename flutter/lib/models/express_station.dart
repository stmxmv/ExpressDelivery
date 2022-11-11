class ExpressStation {
  int id;
  String name;
  String address;

  ExpressStation(this.id, this.name, this.address);

  @override
  String toString() {
    return name;
  }
}
