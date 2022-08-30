class RequestEntity {
  final String title;
  final String body;
  final int id;
  final int userId;
  final int status;

  RequestEntity({
    required this.title,
    required this.body,
    this.id = 0,
    this.userId = 0,
    this.status = 0,
  });
}
