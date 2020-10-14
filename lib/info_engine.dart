import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

import 'package:truyenqq_filter/model/story.dart';

Future initiate(Client client) async {
  var response = await client.get('http://truyenqq.com/index.html');

  var document = parse(response.body);
  List<Element> links = document.querySelectorAll('ul.mega-list > li > a');

  Map<String, dynamic> filters = {};
  for (var link in links) {
    filters[link.text.toString()] = link.attributes['href'];
  }
  return filters;
}

Future getPageNumber(Client client, String url) async {
  if (url == null) {
    exit(0);
  }

  var response = await client.get(url);
  var document = parse(response.body);

  Element final_page = document.querySelector('a.pagination-next');
  var delimiter = url.replaceAll('.html', '/trang-');
  var number_page = final_page.attributes['href']
      .replaceAll(delimiter, '')
      .replaceAll('.html', '');
  return int.parse(number_page);
}

List<String> generateLink(String url, int number) {
  List<String> links = [];
  for (var i = 1; i <= number; i++) {
    var link = url.replaceAll('.html', '/trang-$i.html');
    links.add(link);
  }
  return links;
}

Future<List<Story>> getStories(Client client, String url) async {
  var response = await client.get(url);
  var document = parse(response.body);

  List<Element> stories = document.querySelectorAll('div.story-item');

  List<Story> allInfo = [];
  for (var story in stories) {
    List<String> tags = [];

    var title = story.querySelector('h3.title-book > a').attributes['title'];
    var href = story.querySelector('h3.title-book > a').attributes['href'];
    var chap = story.querySelector('div.episode-book > a').text.substring(7);
    var tag = story.querySelectorAll('a.blue').forEach((element) {
      tags.add(element.text);
    });
    var image = story.querySelector('img.story-cover').attributes['src'];

    allInfo.add(Story(
      title: title,
      link: href,
      chapter: int.tryParse(chap) ?? double.parse(chap),
      tags: tags,
      image: image,
    ));
  }
  return allInfo;
}
