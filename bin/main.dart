import 'package:truyenqq_filter/info_engine.dart' as engine;
import 'package:truyenqq_filter/model/story.dart';

import 'package:http/http.dart';
import 'dart:io';
import 'dart:convert';


void main(List<String> arguments) async {
  var tags =
      stdin.readLineSync(encoding: Encoding.getByName('utf-8')).split(' ');

  var client = Client();
  var filters = await engine.initiate(client);

  List<Story> stories = [];
  int page_number = await engine.getPageNumber(client, filters[tags[0]]);
  var links = engine.generateLink(filters[tags[0]], page_number);

  for (var link in links) {
    await engine.getStories(client, link).then((List<Story> page_stories) {
      page_stories.forEach((story) {
        var flag = true;
        for (var i = 1; i < tags.length; i++) {
          if (story.tags.contains(tags[i]) == false) {
            flag = false;
            break;
          }
        }
        flag == true ? stories.add(story) : null;
      });
    });
  }

  stories.sort((a, b) => b.compareTo(a));
  for (var story in stories) {
    print('${story.title}: ${story.chapter}');
  }
}
