class Like {
  final int likes;
  final List<String> userNames;

  Like({required this.likes, required this.userNames});

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      likes: json['likes'],
      userNames: (json['userNames'] as List).map((e) => e as String).toList(),
    );
  }
  Map<String, dynamic> toJson() => {
        'likes': likes,
        'userNames': userNames,
      };
}

class Comment {
  final String userName;
  final String userImage;
  final String comment;

  Comment(
      {
        required this.userName,
        required this.userImage,
        required this.comment
      });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userName: json['userName'],
      userImage: json['userImage'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userImage': userImage,
      'comment': comment,
    };
  }
}

class Post {
  final String id;
  final String userId;
  final String title;
  final String detail;
  final String imageUrl;
  final String imageId;
  final Like like;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.detail,
    required this.imageUrl,
    required this.imageId,
    required this.like,
    required this.comments,
  });
}
