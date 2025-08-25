import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  bool _isYoutube = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Clean YouTube URL (remove extra query params like ?si=...)
    final videoId = YoutubePlayer.convertUrlToId(
      widget.videoUrl.split("&").first,
    );

    if (videoId != null) {
      _isYoutube = true;
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          forceHD: true,
        ),
      );
    } else {
      // Direct mp4
      _videoController = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          setState(() => _isInitialized = true);
          _videoController!.play();
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _isYoutube
            ? YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _youtubeController!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.redAccent,
                ),
                builder: (context, player) {
                  return Column(
                    children: [
                      player,
                      const SizedBox(height: 10),
                      
                    ],
                  );
                },
              )
            : _isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                  const SizedBox(height: 8),
                  VideoProgressIndicator(
                    _videoController!,
                    allowScrubbing: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    colors: VideoProgressColors(
                      playedColor: Colors.redAccent,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.blue
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),

      floatingActionButton: (!_isYoutube && _isInitialized)
          ? FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                setState(() {
                  _videoController!.value.isPlaying
                      ? _videoController!.pause()
                      : _videoController!.play();
                });
              },
              child: Icon(
                _videoController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
