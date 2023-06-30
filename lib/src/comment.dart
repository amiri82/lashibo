import 'package:lashibo/src/user.dart';

class Comment {
  final String username;
  final String comment;
  final int rating;
  final List<User> usersLiked;
  final List<User> usersDisliked;

  Comment(this.username ,this.comment, this.rating,
      [this.usersLiked = const [], this.usersDisliked = const []]);
}
