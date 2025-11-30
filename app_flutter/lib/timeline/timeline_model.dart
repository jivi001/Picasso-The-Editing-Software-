import 'package:flutter/foundation.dart';

enum ClipType { video, audio, image }

class Clip {
  final String id;
  final String mediaId;
  final String mediaPath;
  final ClipType type;

  // Timeline position
  Duration timelinePosition;

  // In/Out points in source media
  Duration inPoint;
  Duration outPoint;

  // Computed duration
  Duration get duration => outPoint - inPoint;

  // Transform properties
  double positionX;
  double positionY;
  double rotation;
  double scaleX;
  double scaleY;
  double opacity;

  Clip({
    required this.id,
    required this.mediaId,
    required this.mediaPath,
    required this.type,
    required this.timelinePosition,
    required this.inPoint,
    required this.outPoint,
    this.positionX = 0,
    this.positionY = 0,
    this.rotation = 0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.opacity = 1.0,
  });

  Clip copyWith({
    Duration? timelinePosition,
    Duration? inPoint,
    Duration? outPoint,
    double? positionX,
    double? positionY,
    double? rotation,
    double? scaleX,
    double? scaleY,
    double? opacity,
  }) {
    return Clip(
      id: id,
      mediaId: mediaId,
      mediaPath: mediaPath,
      type: type,
      timelinePosition: timelinePosition ?? this.timelinePosition,
      inPoint: inPoint ?? this.inPoint,
      outPoint: outPoint ?? this.outPoint,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      rotation: rotation ?? this.rotation,
      scaleX: scaleX ?? this.scaleX,
      scaleY: scaleY ?? this.scaleY,
      opacity: opacity ?? this.opacity,
    );
  }
}

class Track {
  final String id;
  final String name;
  final ClipType type;
  final List<Clip> clips;
  bool isLocked;
  bool isVisible;
  double volume; // For audio tracks

  Track({
    required this.id,
    required this.name,
    required this.type,
    List<Clip>? clips,
    this.isLocked = false,
    this.isVisible = true,
    this.volume = 1.0,
  }) : clips = clips ?? [];

  void addClip(Clip clip) {
    clips.add(clip);
    clips.sort((a, b) => a.timelinePosition.compareTo(b.timelinePosition));
  }

  void removeClip(String clipId) {
    clips.removeWhere((c) => c.id == clipId);
  }

  List<Clip> getClipsAtTime(Duration time) {
    return clips.where((clip) {
      final start = clip.timelinePosition;
      final end = start + clip.duration;
      return time >= start && time < end;
    }).toList();
  }
}

class Timeline extends ChangeNotifier {
  final List<Track> videoTracks;
  final List<Track> audioTracks;
  Duration _playheadPosition = Duration.zero;
  Duration _duration = const Duration(minutes: 10);

  Timeline({
    List<Track>? videoTracks,
    List<Track>? audioTracks,
  })  : videoTracks = videoTracks ?? [],
        audioTracks = audioTracks ?? [];

  Duration get playheadPosition => _playheadPosition;
  Duration get duration => _duration;

  void setPlayheadPosition(Duration position) {
    _playheadPosition = position;
    notifyListeners();
  }

  void addVideoTrack() {
    videoTracks.add(Track(
      id: 'v${videoTracks.length + 1}',
      name: 'Video ${videoTracks.length + 1}',
      type: ClipType.video,
    ));
    notifyListeners();
  }

  void addAudioTrack() {
    audioTracks.add(Track(
      id: 'a${audioTracks.length + 1}',
      name: 'Audio ${audioTracks.length + 1}',
      type: ClipType.audio,
    ));
    notifyListeners();
  }

  void insertClip(Clip clip, Track track) {
    track.addClip(clip);
    _updateDuration();
    notifyListeners();
  }

  void removeClip(String clipId, Track track) {
    track.removeClip(clipId);
    _updateDuration();
    notifyListeners();
  }

  void _updateDuration() {
    Duration maxDuration = Duration.zero;

    for (var track in [...videoTracks, ...audioTracks]) {
      for (var clip in track.clips) {
        final clipEnd = clip.timelinePosition + clip.duration;
        if (clipEnd > maxDuration) {
          maxDuration = clipEnd;
        }
      }
    }

    _duration = maxDuration;
  }

  List<Clip> getActiveClipsAtTime(Duration time) {
    final clips = <Clip>[];

    for (var track in videoTracks) {
      if (track.isVisible) {
        clips.addAll(track.getClipsAtTime(time));
      }
    }

    return clips;
  }
}
