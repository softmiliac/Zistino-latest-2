class ReviewModel {
  String text;
  bool type;
  ReviewModel(this.text, this.type);

  Map<String, dynamic> toJson() => {
    'text': text,
    'type': type,

  };
}