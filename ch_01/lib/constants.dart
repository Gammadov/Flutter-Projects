import 'package:flutter/material.dart';

const String image_link =
    'https://ctftime.org/media/team/7867CF13-2861-41A6-A7E8-7CDC1BC722AD.png';
const String caption_text = 'A "Hello World" program in Piet';
const String description_text =
    '''A "Hello, World!" program is generally a computer program that ignores any input and outputs or displays a message similar to "Hello, World!". A small piece of code in most general-purpose programming languages, this program is used to illustrate a language's basic syntax.''';

final Uri wiki_article =
    Uri.parse('https://en.wikipedia.org/wiki/%22Hello,_World!%22_program');

Widget caption() {
  return Text(
    caption_text,
    style: TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
  );
}

Widget description() {
  return Text(
    description_text,
    style: TextStyle(fontSize: 16),
  );
}
