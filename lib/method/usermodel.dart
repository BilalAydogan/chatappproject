class UserModel {
  final String id;
  final String name;
  final String email;
  final String backImageUrl;
  final String profileImageUrl;
  final String status;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.backImageUrl,
      required this.profileImageUrl,
      required this.status});
}
