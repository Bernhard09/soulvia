import 'package:flutter/widgets.dart';

class MindCardModel {
  final String text;
  final Color bgColor;
  final String? imagePath; // Bisa null jika ingin pakai Icon
  final IconData? iconData; // Untuk matahari (karena belum ada assetnya)
  final String correctAction; // 'buang' atau 'simpan'

  MindCardModel({
    required this.text,
    required this.bgColor,
    this.imagePath,
    this.iconData,
    required this.correctAction,
  });
}