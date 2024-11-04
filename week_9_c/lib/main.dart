import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

void main() {
  runApp(MaterialApp(
    title: 'YouTube Player Example',
    home: YouTubePlayerScreen(),
  ));
}

class YouTubePlayerScreen extends StatefulWidget {
  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState(); // Don't forget to call super.initState()
    _controller = YoutubePlayerController.fromVideoId(
      videoId: '6QwKfRpCJes', // Replace with your desired video ID
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close(); // Close the controller when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Player'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9, // Set the aspect ratio for the player
          child: YoutubePlayer(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
