import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:shop/utils/constants.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({Key? key}) : super(key: key);

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  late AssetsAudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AssetsAudioPlayer.newPlayer();
    _audioPlayer.open(
      Audio('assets/audios/pedro.mp3'),
      autoStart: Constants.autoStartAudio,
      volume: 1,
      loopMode: LoopMode.single,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return PlayerBuilder.isPlaying(
      player: _audioPlayer,
      builder: (_, final bool isPlaying) {
        return IconButton(
          onPressed: _audioPlayer.playOrPause,
          icon: Icon(
            isPlaying ? Icons.pause_outlined : Icons.play_arrow,
            size: 32,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.pause();
    _audioPlayer.dispose();
  }
}
