class GratitudePost {
  final String id;
  String name;
  final String date;
  final String content;
  final bool isSaved;
  final List<String> images; // <-- Tambahan untuk menampung gambar

  GratitudePost({
    required this.id,
    required this.name,
    required this.date,
    required this.content,
    this.isSaved = false,
    this.images = const [], // Default kosong
  });

  GratitudePost copyWith({bool? isSaved, List<String>? images}) {
    return GratitudePost(
      id: id,
      name: name,
      date: date,
      content: content,
      isSaved: isSaved ?? this.isSaved,
      images: images ?? this.images,
    );
  }
}