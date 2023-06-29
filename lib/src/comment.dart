import 'package:lashibo/src/user.dart';

class Comment {
  final String name;
  final int rating;
  final List<User> usersLiked;
  final List<User> usersDisliked;

  Comment(this.name, this.rating,
      [this.usersLiked = const [], this.usersDisliked = const []]);
}
