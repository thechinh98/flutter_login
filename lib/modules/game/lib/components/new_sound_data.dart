import 'package:audioplayers/audioplayers.dart';
import 'package:game/utils/constant.dart';

class NewSoundData {
  String? id;
  String? questionId;
  String sound = "";
  double orderIndex = 0;
  Duration duration = Duration(seconds: 0);
  Duration position = Duration(seconds: 0);
  bool isLocal = false;
  bool isQuestion = true;
  bool isHintSound = false;
  AudioPlayerState? playerState;

  // NewSoundData();
  get isPlaying => playerState == AudioPlayerState.PLAYING;

  get isPaused => playerState == AudioPlayerState.PAUSED;

  get durationText =>
      duration
          .toString()
          .split('.')
          .first;

  get positionText =>
      position
          .toString()
          .split('.')
          .first;

  NewSoundData.fromGameObject(
      {required String? questionId, required String? sound, bool? isLocal}) {
    this.questionId = questionId;
    if (sound == null) {
      return;
    }
    if (sound.startsWith("http")) {
      this.sound = sound;
    } else {
      if (sound.startsWith("/")) {
        this.sound = '$GOOGLE_CLOUD_STORAGE_URL' + sound;
      } else {
        this.sound = '$GOOGLE_CLOUD_STORAGE_URL/' + sound;
      }
    }
    if (isLocal != null && isLocal) {
      this.isLocal = isLocal;
    }
  }

  updateDuration(Duration _duration) {
    duration = _duration;
    if (duration.inSeconds < 1) {
      duration = Duration(seconds: 1);
    }
  }

  updatePosition(Duration _position) {
    position = _position;
    if (position.inMilliseconds > duration.inMilliseconds) {
      position = duration;
    }
  }

  pause() {
    playerState = AudioPlayerState.PAUSED;
  }

  stop() {
    playerState = AudioPlayerState.STOPPED;
    resetDuration();
  }

  play() {
    playerState = AudioPlayerState.PLAYING;
  }

  complete() {
    playerState = AudioPlayerState.COMPLETED;
    position = duration;
  }

  onError() {
    duration = Duration(seconds: 0);
    position = Duration(seconds: 0);
  }

  reset() {
    duration = Duration(seconds: 0);
    position = Duration(seconds: 0);
    playerState = null;
  }

  resetDuration() {
    duration = Duration(seconds: 0);
    position = Duration(seconds: 0);
  }
}
