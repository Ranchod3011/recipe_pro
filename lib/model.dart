class RecipeModel{
  final String label;
  final String imageUrl;
  final String url;

  RecipeModel({
    required this.label,
    required this.imageUrl,
    required this.url
  });

  factory RecipeModel.fromMap(Map recipe){
    return RecipeModel(
        label: recipe["label"],
        imageUrl: recipe["image"],
        url: recipe["url"]
    );
  }
}