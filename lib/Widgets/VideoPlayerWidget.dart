import 'package:flutter/material.dart';
import 'package:goraku/Models/SourceModel.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final List<SourceModel> urls;

  VideoPlayerWidget({Key? key, required this.urls}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  String selectedQuality = "default";

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.urls
          .firstWhere((element) => element.quality == selectedQuality)
          .url),
      formatHint:
          widget.urls.first.isM3U8 ? VideoFormat.hls : VideoFormat.other,
    );

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      allowPlaybackSpeedChanging: false,
      allowMuting: true,
      showOptions: true,
      additionalOptions: (BuildContext context) {
        return <OptionItem>[
          OptionItem(
            onTap: () {
              _showQualityDialog(context);
            },
            iconData: Icons.video_settings_outlined,
            title: "Video Quality",
          ),
        ];
      },
      cupertinoProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white,
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white,
      ),
      showControlsOnInitialize: true,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  void _showQualityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Video Quality"),
          content: DropdownButton<String>(
            value: selectedQuality,
            items: widget.urls.map((source) {
              return DropdownMenuItem<String>(
                value: source.quality,
                child: Text(source.quality),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                _onQualitySelected(newValue);
                Navigator.of(context).pop();
              }
            },
          ),
        );
      },
    );
  }

  void _onQualitySelected(String quality) {
    setState(() {
      selectedQuality = quality;
      _videoPlayerController.pause();
      setState(() {
        selectedQuality = quality;
      });
      _initializeVideoPlayer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
