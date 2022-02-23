class MovieModel {
  final String id;
  final String title;
  final String descr;
  String img;
  final String date;
  final String time;

  MovieModel(
      {required this.id,
      required this.title,
      required this.descr,
      required this.img,
      required this.date,
      required this.time});
}
