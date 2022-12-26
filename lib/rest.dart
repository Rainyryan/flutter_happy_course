class Rest {
  String title;
  String plot;
  String imagePath;

  Rest({
    required this.title,
    required this.plot,
    required this.imagePath,
  });

  factory Rest.fromJson(Map<String, dynamic> json){
    const nullImage = 'asset/null.jpg';
    return Rest(
      title: json['name'] as String,
      imagePath:
      (json['photo']['images'] == null)
          ? nullImage
          : json['photo']['images']['original']['url'],
      plot: (json['description'] == null)
          ? 'no desc'
          : json['description'],
    );
  }
}
