class Level {
  const Level({
    required this.minLivesCount,
    required this.maxLivesCount,
    required this.title,
    required this.imageAssetNames,
    required this.message,
  });

  final int minLivesCount;
  final int maxLivesCount;
  final String title;
  final List<String> imageAssetNames;
  final String message;
}
