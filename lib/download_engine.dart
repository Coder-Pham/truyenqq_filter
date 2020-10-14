import 'dart:io';

void downloadJPG(String url) {
  var client = HttpClient();
  client
      .getUrl(Uri.parse(url))
      .then((HttpClientRequest request) => request.close())
      .then(
    (HttpClientResponse response) {
      if (response.statusCode != 200) {
        print('Error code: ${response.statusCode}');
      } else {
        response.pipe(File('./logo_pipe.jpg').openWrite());
      }
    },
  );
}
