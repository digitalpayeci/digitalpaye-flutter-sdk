class Jsonable {
  const Jsonable();

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  factory Jsonable.fromJson(Map<String, dynamic> json) {
    return Jsonable.fromJson(json);
  }
}
