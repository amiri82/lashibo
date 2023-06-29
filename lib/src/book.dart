import 'comment.dart';

enum BookType {
  audioBook,
  textBook,
}

enum Category{
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
  }){
    if(comments.isNotEmpty){
      for(final comment in comments){
        rating += comment.rating;
      }
      rating /= comments.length;
    }
  }
}