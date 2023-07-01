import 'package:lashibo/src/user.dart';

enum BookType {
  audioBook,
  textBook,
}

enum Category{
  all,
  fiction,
  history,
  biography,
  classic,
  adventure,
  science,
  novel,
  thriller,
  nonFiction,
}
enum Filter{
  bestSeller,
  mostRecent,
  highestRating,
}

enum Status{
  notBought,
  bought,
  stillReading,
  notBoughtPremium,
  soldOut,
  free,
}

class Book {
  final String title;
  final String description;
  final String imageAddress;
  final String author;
  final BookType bookType;
  int quantityLeft;
  int price;
  double rating;
  final List<Comment> comments;
  final Category category;
  final bool isPremium;

  Book({required this.title,
    required this.description,
    required this.price,
    required this.quantityLeft,
    required this.author,
    required this.bookType,
    required this.category,
    required this.imageAddress,
    this.rating = 0,
    this.comments = const[],
    this.isPremium = false,
  }){
    if(comments.isNotEmpty){
      for(final comment in comments){
        rating += comment.rating;
      }
      rating /= comments.length;
    }
  }

  Book addComment(Comment comment){
    comments.add(comment);
    return this;
  }
}

class Comment {
  final String username;
  final String comment;
  final int rating;
  final List<User> usersLiked;
  final List<User> usersDisliked;

  Comment(this.username ,this.comment, this.rating,
      [this.usersLiked = const [], this.usersDisliked = const []]);
}