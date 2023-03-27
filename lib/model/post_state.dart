

class Like{
  final int likes;
  final List<String> usernames;


  Like({
    required this.likes,
    required this.usernames,

  });
  factory Like.fromJson(Map<String, dynamic> json){
    return Like(
        likes: json['likes'],
        usernames:  (json['usernames'] as List).map((e) => e as String).toList(),

    );
  }
}

class Comment{
  final String username;
  final String comment;
  final String dateTime;

  Comment({required this.username, required this.comment,required this.dateTime});

  factory Comment.fromJson(Map<String, dynamic> json){
    return  Comment(
        comment:  json['comment'],
        username: json['username'],
        dateTime: json['dateTime']
    );
  }


  Map<String, dynamic> toJson(){
    return {
      'comment': this.comment,
      'username': this.username,
      'dateTime' : this.dateTime
    };
  }


}

class Post{
  final String id;
  final String caption;
  final String imageUrl;
  final String userId;
  final Like like;
  final String imageId;
  final List<Comment> comments;


  Post({
    required this.imageUrl,
    required this.like,
    required this.userId,
    required this.caption,
    required this.id,
    required this.comments,
    required this.imageId
  });

}

class Notes{
  final String id;
  final String userName;
  final String notes;
  final String userId;
  final String dateTime;
  final Like like;


  Notes({
    required this.like,
    required this.userId,
    required this.notes,
    required this.dateTime,
    required this.id,
    required this.userName
  });

}


class Wall{
  final String id;
  late final String imageUrl;
  final String userId;
  final String imageId;


  Wall({
    required this.imageUrl,
    required this.userId,
    required this.id,
    required this.imageId
  });

}
