import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:game/components/new_sound_data.dart';
import 'package:game/utils/constant.dart';

class AudioModel extends ChangeNotifier {
  late AudioPlayer audioPlayer;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerErrorSubscription;
  StreamSubscription? _playerStateSubscription;

  List<NewSoundData> sounds = [];
  List<NewSoundData> speakingPracticeSounds = [];

  NewSoundData? currentSound;
  double speed = 1.0;
  bool isLoading = false;
  bool isPlaylistMode = false;
  bool isSpeakingPracticeMode = false;
  bool callBackToSpeakingPractice = false;
  AudioModel() {
    audioPlayer = AudioPlayer();
    if (Platform.isIOS) {
      audioPlayer.startHeadlessService();
    }
    initAudio();
  }
  initAudio() async {
    _durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
      // setState(() => _duration = duration);
      if (currentSound != null) {
        if (currentSound?.duration == null ||
            currentSound!.duration == Duration(seconds: 0)) {
          currentSound!.updateDuration(duration);
          notifyListeners();
        }
      }
    });

    _positionSubscription = audioPlayer.onAudioPositionChanged.listen((p) {
      if (currentSound != null &&
          currentSound!.playerState == AudioPlayerState.PLAYING) {
        currentSound!.updatePosition(p);
        notifyListeners();
      }
    });

    _playerCompleteSubscription =
        audioPlayer.onPlayerCompletion.listen((event) {
      if (currentSound != null &&
          currentSound!.playerState == AudioPlayerState.PLAYING) {
        // print("SET COMPLETE:");
        currentSound!.complete();

        if (isPlaylistMode) {
          print("SET COMPLETE: isPlaylistMode");
          NewSoundData? nextSound = sounds.firstWhereOrNull(
              (element) => element.orderIndex > currentSound!.orderIndex);
          if (nextSound != null) {
            play(nextSound);
          } else {
            sounds.forEach((element) {
              element.reset();
            });
            currentSound = sounds.first;
            notifyListeners();
          }
        } else if (isSpeakingPracticeMode) {
          // Mode for User Speaking
          print("SET COMPLETE: isSpeakingPracticeMode");
          speakingPracticeSounds.forEach((element) {
            print(": ${element.questionId} ====== ${element.sound} : ${element.orderIndex}");
          });
          NewSoundData? nextSound = speakingPracticeSounds.firstWhereOrNull(
              (element) => (element.orderIndex > currentSound!.orderIndex));
          if (nextSound != null) {
            print("${nextSound.sound}");
            if (nextSound.isHintSound) {
              //call back to speaking
              print("SET COMPLETE: call back to speaking");

              callBackToSpeakingPractice = true;
              notifyListeners();
              callBackToSpeakingPractice = false;
            } else {
              print("Play nextSound ");
              play(nextSound);
            }
          } else {
            print("Reset");
            speakingPracticeSounds.forEach((element) {
              element.reset();
            });
            // currentSound = sounds.first;
            notifyListeners();
          }
        } else {
          notifyListeners();
        }
      }
    });
    _playerErrorSubscription = audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      print('onPlayerStateChanged : $state');
    });

    audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      print('onNotificationPlayerStateChanged : $state');
    });
  }

  cancel() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
  }

  resetSpeakingPracticeMode() {
    isPlaylistMode = true;
    isSpeakingPracticeMode = false;
    notifyListeners();
  }

  resetList() async {
    await audioPlayer.stop();
    currentSound = null;
    sounds.forEach((element) {
      element.reset();
    });
    speakingPracticeSounds.forEach((element) {
      element.reset();
    });
  }

   loadData(List<NewSoundData> _sounds, bool isSpeakingMode) {
    // sounds = [];
    if (!isSpeakingMode) {
      sounds = _sounds;
      currentSound = sounds.first;
    } else {
      speakingPracticeSounds = _sounds;
      currentSound = speakingPracticeSounds.first;
      changeToSpeakingPracticeMode();
    }

    // print(_sounds.length);
    notifyListeners();
  }

  changeToSpeakingPracticeMode() {
    isPlaylistMode = false;
    isSpeakingPracticeMode = true;
    notifyListeners();
  }

  setSpeed(double _speed) async {
    speed = _speed;
    try {
      await audioPlayer.setPlaybackRate(playbackRate: _speed);
    } catch (e) {}
    notifyListeners();
  }

  reset() {
    sounds = [];
    speakingPracticeSounds = [];
    currentSound = null;
    isLoading = false;
    isPlaylistMode = false;
    speed = 1.0;
    try {
      stop();
    } catch (e) {
      print("EXCEPTION AUDIO MODEL: $e");
    }
  }

  play(NewSoundData? _soundData, [bool isLocal = false]) async {
    isLoading = true;
    if (_soundData != null && _soundData != currentSound) {
      currentSound = _soundData;
    }
    if (currentSound!.playerState == AudioPlayerState.PAUSED) {
      resume();
    } else {
      currentSound!.play();

      int result = await audioPlayer.play(
        currentSound!.sound,
        isLocal: isLocal,
      );
      if (result == 1) {
        if (speed != 1.0) {
          await audioPlayer.setPlaybackRate(playbackRate: speed);
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }

  pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      print('pause done');
    }
    notifyListeners();
  }

  stop() async {
    int result = await audioPlayer.stop();
  }

  seek() async {
    int result = await audioPlayer.seek(Duration(milliseconds: 1200));
  }

  resume() async {
    int result = await audioPlayer.resume();
  }

  playInSpeakingPractice(
      List<NewSoundData> speakingSoundList, bool questionClicked) {
    speakingPracticeSounds = speakingSoundList;
    if (questionClicked) {
      NewSoundData? questionSound = speakingPracticeSounds
          .firstWhereOrNull((element) => element.isQuestion);
      if (questionSound != null) {
        play(questionSound);
      }
    }
  }
}
