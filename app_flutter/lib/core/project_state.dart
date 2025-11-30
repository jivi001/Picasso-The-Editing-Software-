import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../timeline/timeline_model.dart';

class ProjectState extends ChangeNotifier {
  final List<FileSystemEntity> _mediaPool = [];
  final Timeline _timeline = Timeline();
  final Timeline _sourceTape = Timeline(); // Virtual timeline for Source Tape
  final _uuid = const Uuid();
  FileSystemEntity? _selectedMedia;

  // Source Marking
  Duration? _sourceInPoint;
  Duration? _sourceOutPoint;

  List<FileSystemEntity> get mediaPool => List.unmodifiable(_mediaPool);
  Timeline get timeline => _timeline;
  Timeline get sourceTape => _sourceTape;
  FileSystemEntity? get selectedMedia => _selectedMedia;
  Duration? get sourceInPoint => _sourceInPoint;
  Duration? get sourceOutPoint => _sourceOutPoint;

  void selectMedia(FileSystemEntity? file) {
    _selectedMedia = file;
    notifyListeners();
  }

  void markIn() {
    _sourceInPoint = _sourceTape.playheadPosition;
    notifyListeners();
  }

  void markOut() {
    _sourceOutPoint = _sourceTape.playheadPosition;
    notifyListeners();
  }

  void clearMarks() {
    _sourceInPoint = null;
    _sourceOutPoint = null;
    notifyListeners();
  }

  Duration _calculateDuration(Duration defaultDuration) {
    if (_sourceInPoint != null && _sourceOutPoint != null) {
      return _sourceOutPoint! - _sourceInPoint!;
    }
    return defaultDuration;
  }

  Duration _calculateInPoint() {
    return _sourceInPoint ?? Duration.zero;
  }

  ProjectState() {
    // Initialize with default tracks
    _timeline.addVideoTrack();
    _timeline.addAudioTrack();

    // Initialize Source Tape with one video track
    _sourceTape.addVideoTrack();
  }

  void addMedia(FileSystemEntity file) {
    if (!_mediaPool.any((f) => f.path == file.path)) {
      _mediaPool.add(file);
      _addToSourceTape(file);
      notifyListeners();
    }
  }

  void removeMedia(FileSystemEntity file) {
    _mediaPool.removeWhere((f) => f.path == file.path);
    _removeFromSourceTape(file);
    notifyListeners();
  }

  void _addToSourceTape(FileSystemEntity file) {
    if (_sourceTape.videoTracks.isEmpty) return;

    final track = _sourceTape.videoTracks.first;
    Duration insertTime = Duration.zero;
    if (track.clips.isNotEmpty) {
      final lastClip = track.clips.last;
      insertTime = lastClip.timelinePosition + lastClip.duration;
    }

    final newClip = Clip(
      id: _uuid.v4(),
      mediaId: file.path,
      mediaPath: file.path,
      type: ClipType.video,
      timelinePosition: insertTime,
      inPoint: Duration.zero,
      outPoint: const Duration(seconds: 5), // Default 5s
    );

    _sourceTape.insertClip(newClip, track);
  }

  void _removeFromSourceTape(FileSystemEntity file) {
    if (_sourceTape.videoTracks.isEmpty) return;
    final track = _sourceTape.videoTracks.first;

    final clipsToRemove =
        track.clips.where((c) => c.mediaPath == file.path).toList();
    for (var clip in clipsToRemove) {
      _sourceTape.removeClip(clip.id, track);
    }

    _rebuildSourceTape();
  }

  void _rebuildSourceTape() {
    if (_sourceTape.videoTracks.isEmpty) return;
    final track = _sourceTape.videoTracks.first;

    Duration currentTime = Duration.zero;
    final sortedClips =
        List<Clip>.from(track.clips); // Already sorted by position usually

    track.clips.clear();

    for (var clip in sortedClips) {
      final updatedClip = clip.copyWith(timelinePosition: currentTime);
      track.addClip(updatedClip);
      currentTime += updatedClip.duration;
    }
  }

  void smartInsert(FileSystemEntity file) {
    if (_timeline.videoTracks.isEmpty) return;
    final track = _timeline.videoTracks.first;
    final playhead = _timeline.playheadPosition;

    final clipsAtPlayhead = track.getClipsAtTime(playhead);

    final newClipDuration = _calculateDuration(const Duration(seconds: 5));
    final newClipInPoint = _calculateInPoint();

    final newClip = Clip(
      id: _uuid.v4(),
      mediaId: file.path,
      mediaPath: file.path,
      type: ClipType.video,
      timelinePosition: playhead,
      inPoint: newClipInPoint,
      outPoint: newClipInPoint + newClipDuration,
    );

    if (clipsAtPlayhead.isNotEmpty) {
      final originalClip = clipsAtPlayhead.first;
      final splitPoint = playhead - originalClip.timelinePosition;

      final part1 = originalClip.copyWith(
        outPoint: originalClip.inPoint + splitPoint,
      );

      final part2 = originalClip.copyWith(
        id: _uuid.v4(),
        timelinePosition: playhead + newClipDuration,
        inPoint: originalClip.inPoint + splitPoint,
      );

      track.removeClip(originalClip.id);
      track.addClip(part1);
      track.addClip(newClip);
      track.addClip(part2);

      final subsequentClips = track.clips
          .where((c) =>
              c.id != part1.id &&
              c.id != newClip.id &&
              c.id != part2.id &&
              c.timelinePosition > originalClip.timelinePosition)
          .toList();

      for (var clip in subsequentClips) {
        track.removeClip(clip.id);
        track.addClip(clip.copyWith(
          timelinePosition: clip.timelinePosition + newClipDuration,
        ));
      }
    } else {
      final subsequentClips =
          track.clips.where((c) => c.timelinePosition >= playhead).toList();

      for (var clip in subsequentClips) {
        track.removeClip(clip.id);
        track.addClip(clip.copyWith(
          timelinePosition: clip.timelinePosition + newClipDuration,
        ));
      }

      track.addClip(newClip);
    }

    _timeline.refresh();
  }

  void placeOnTop(FileSystemEntity file) {
    if (_timeline.videoTracks.length < 2) {
      _timeline.addVideoTrack();
    }

    final track = _timeline.videoTracks[1]; // V2
    final playhead = _timeline.playheadPosition;

    final newClipDuration = _calculateDuration(const Duration(seconds: 5));
    final newClipInPoint = _calculateInPoint();

    final newClip = Clip(
      id: _uuid.v4(),
      mediaId: file.path,
      mediaPath: file.path,
      type: ClipType.video,
      timelinePosition: playhead,
      inPoint: newClipInPoint,
      outPoint: newClipInPoint + newClipDuration,
    );

    _timeline.insertClip(newClip, track);
  }

  void rippleOverwrite(FileSystemEntity file) {
    if (_timeline.videoTracks.isEmpty) return;
    final track = _timeline.videoTracks.first;
    final playhead = _timeline.playheadPosition;

    final clipsAtPlayhead = track.getClipsAtTime(playhead);

    if (clipsAtPlayhead.isEmpty) {
      smartInsert(file);
      return;
    }

    final originalClip = clipsAtPlayhead.first;

    final newClipDuration = _calculateDuration(const Duration(seconds: 5));
    final newClipInPoint = _calculateInPoint();

    final newClip = Clip(
      id: _uuid.v4(),
      mediaId: file.path,
      mediaPath: file.path,
      type: ClipType.video,
      timelinePosition: originalClip.timelinePosition,
      inPoint: newClipInPoint,
      outPoint: newClipInPoint + newClipDuration,
    );

    final durationDiff = newClipDuration - originalClip.duration;

    track.removeClip(originalClip.id);
    track.addClip(newClip);

    if (durationDiff != Duration.zero) {
      final subsequentClips = track.clips
          .where((c) =>
              c.id != newClip.id &&
              c.timelinePosition > newClip.timelinePosition)
          .toList();

      for (var clip in subsequentClips) {
        track.removeClip(clip.id);
        track.addClip(clip.copyWith(
          timelinePosition: clip.timelinePosition + durationDiff,
        ));
      }
    }
    _timeline.refresh();
  }

  void closeUp() {
    if (_timeline.videoTracks.isEmpty) return;
    final trackV1 = _timeline.videoTracks.first;
    final playhead = _timeline.playheadPosition;

    final clipsAtPlayhead = trackV1.getClipsAtTime(playhead);

    if (clipsAtPlayhead.isEmpty) return;

    final originalClip = clipsAtPlayhead.first;

    if (_timeline.videoTracks.length < 2) {
      _timeline.addVideoTrack();
    }
    final trackV2 = _timeline.videoTracks[1];

    final offsetInClip = playhead - originalClip.timelinePosition;
    final remainingInClip = originalClip.duration - offsetInClip;

    Duration closeUpDuration = const Duration(seconds: 5);
    if (remainingInClip < closeUpDuration) {
      closeUpDuration = remainingInClip;
    }

    if (closeUpDuration < const Duration(milliseconds: 500)) return;

    final newClip = originalClip.copyWith(
      id: _uuid.v4(),
      timelinePosition: playhead,
      inPoint: originalClip.inPoint + offsetInClip,
      outPoint: originalClip.inPoint + offsetInClip + closeUpDuration,
      scaleX: 2.0,
      scaleY: 2.0,
    );

    _timeline.insertClip(newClip, trackV2);
  }

  void sourceOverwrite(FileSystemEntity file) {
    if (_timeline.videoTracks.isEmpty) return;
    final track = _timeline.videoTracks.first;
    final playhead = _timeline.playheadPosition;

    final newClipDuration = _calculateDuration(const Duration(seconds: 5));
    final newClipInPoint = _calculateInPoint();

    final newClip = Clip(
      id: _uuid.v4(),
      mediaId: file.path,
      mediaPath: file.path,
      timelinePosition: playhead,
      inPoint: newClipInPoint,
      outPoint: newClipInPoint + newClipDuration,
      type: ClipType.video,
    );

    final end = playhead + newClipDuration;
    track.clips.removeWhere((c) {
      final cStart = c.timelinePosition;
      final cEnd = c.timelinePosition + c.duration;
      return (cStart >= playhead && cEnd <= end) ||
          (cStart < playhead && cEnd > playhead) ||
          (cStart < end && cEnd > end);
    });

    track.addClip(newClip);
    track.clips
        .sort((a, b) => a.timelinePosition.compareTo(b.timelinePosition));

    _timeline.refresh();
  }

  void addClipToTimeline(FileSystemEntity file) {
    final clipId = _uuid.v4();
    final mediaId = file.path;

    Duration insertTime = Duration.zero;
    if (_timeline.videoTracks.isNotEmpty) {
      final track = _timeline.videoTracks.first;
      if (track.clips.isNotEmpty) {
        final lastClip = track.clips.last;
        insertTime = lastClip.timelinePosition + lastClip.duration;
      }
    }

    final newClipDuration = _calculateDuration(const Duration(seconds: 5));
    final newClipInPoint = _calculateInPoint();

    final newClip = Clip(
      id: clipId,
      mediaId: mediaId,
      mediaPath: file.path,
      type: ClipType.video,
      timelinePosition: insertTime,
      inPoint: newClipInPoint,
      outPoint: newClipInPoint + newClipDuration,
    );

    if (_timeline.videoTracks.isNotEmpty) {
      _timeline.insertClip(newClip, _timeline.videoTracks.first);
      notifyListeners();
    }
  }
}
