class GenereCategory {
  String name;
  int id;

  GenereCategory({
    required this.name,
    required this.id,
  });

  factory GenereCategory.fromJson(Map<String, dynamic> json) {
    return GenereCategory(
      name: json["name"],
      id: json["id"],
    );
  }
}
