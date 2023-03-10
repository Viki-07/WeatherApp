// To parse this JSON data, do
//
//     final quotesPost = quotesPostFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

QuotesPost quotesPostFromJson(String str) => QuotesPost.fromJson(json.decode(str));

String quotesPostToJson(QuotesPost data) => json.encode(data.toJson());

class QuotesPost {
    QuotesPost({
        required this.id,
        required this.content,
        required this.author,
        required this.tags,
        required this.authorSlug,
        required this.length,
        required this.dateAdded,
        required this.dateModified,
    });

    String id;
    String content;
    String author;
    List<String> tags;
    String authorSlug;
    int length;
    DateTime dateAdded;
    DateTime dateModified;

    factory QuotesPost.fromJson(Map<String, dynamic> json) => QuotesPost(
        id: json["_id"],
        content: json["content"],
        author: json["author"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        authorSlug: json["authorSlug"],
        length: json["length"],
        dateAdded: DateTime.parse(json["dateAdded"]),
        dateModified: DateTime.parse(json["dateModified"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "content": content,
        "author": author,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "authorSlug": authorSlug,
        "length": length,
        "dateAdded": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "dateModified": "${dateModified.year.toString().padLeft(4, '0')}-${dateModified.month.toString().padLeft(2, '0')}-${dateModified.day.toString().padLeft(2, '0')}",
    };
}
