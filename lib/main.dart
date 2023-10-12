import 'dart:io';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Video Downloader',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InstagramVideoDownloader(),
    );
  }
}

class InstagramVideoDownloader extends StatefulWidget {
  @override
  _InstagramVideoDownloaderState createState() =>
      _InstagramVideoDownloaderState();
}

class _InstagramVideoDownloaderState extends State<InstagramVideoDownloader> {
  late VideoPlayerController _controller;
  FlutterInsta flutterInsta = FlutterInsta();

  @override
  void initState() {
    super.initState();
    // _downloadVideo().then((filePath) {
    //   _controller = VideoPlayerController.file(File(filePath))
    //     ..initialize().then((_) {
    //       setState(() {});
    //       _controller.play();
    //     });
    // });
  }

  extractData(String link) async {
    // final response = await http.get(Uri.parse(link));
    String downloadLink = await flutterInsta
        .downloadReels("https://www.instagram.com/reel/CDlGkdZgB2y/"); //URL

    // print("response: ${response.body}");

    // final RegExp videoRegex = RegExp(r'videoURL":"(https:\/\/[^"]+.mp4)"');
    // final RegExp usernameRegex = RegExp(r'username":"([^"]+)"');

    // final videoMatch = videoRegex.firstMatch(response.body);
    // final usernameMatch = usernameRegex.firstMatch(response.body);

    // return {
    //   'videoUrl': videoMatch?.group(1),
    //   'username': usernameMatch?.group(1)
    // };
  }

  _downloadVideo() async {
    String? videoUrl = await flutterInsta
        .downloadReels("https://www.instagram.com/reel/CDlGkdZgB2y/"); //URL
    print("video url: $videoUrl");
    // final response = await http.get(Uri.parse(videoUrl));
    // print("Response: ${response.body}");
    await flutterInsta.getProfileData("am_ali_asghar");
    print("Username : ${flutterInsta.username}");
    print("Followers : ${flutterInsta.followers}");
    print("Folowing : ${flutterInsta.following}");
    print("Bio : ${flutterInsta.bio}");
    print("Website : ${flutterInsta.website}");
    print("Profile Image : ${flutterInsta.imgurl}");

    if (videoUrl == null) {
      throw Exception("Failed to extract video URL.");
    }
    var response = await http.get(Uri.parse(videoUrl));
    var documentDirectory = await getApplicationDocumentsDirectory();
    var filePath = p.join(documentDirectory.path, 'instagram_video.mp4');
    File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    print("Video saved to $filePath");

    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instagram Video Downloader"),
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              _downloadVideo();
            },
            child: Text("Downlaod Video")),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
