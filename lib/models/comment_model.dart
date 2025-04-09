class CommentModel {
  final String author;
  final String content;
  final DateTime date;

  CommentModel({
    required this.author,
    required this.content,
    required this.date,
  });

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Juste maintenant';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} h';
    return '${diff.inDays} j';
  }
}