class Review {
  final String uid;
  final String doctorId;
  final String review;
  final int rating;
  final DateTime date;

  var userimage;

  var username;

  Review({
    required this.uid,
    required this.doctorId,
    required this.review,
    required this.rating,
    required this.date,
    required this.userimage,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'doctorId': doctorId,
      'review': review,
      'rating': rating,
      'date': date.toIso8601String(),
      'imageUrl': userimage,
      'name': username,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      userimage: map['name'],
      username: map['imageUrl'],
      uid: map['uid'],
      doctorId: map['doctorId'],
      review: map['review'],
      rating: map['rating'],
      date: DateTime.parse(map['date']),
    );
  }
}
