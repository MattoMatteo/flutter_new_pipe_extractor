import 'dart:convert';
import 'dart:io';

import 'package:flutter_new_pipe_extractor/flutter_new_pipe_extractor.dart';
import 'package:flutter_test/flutter_test.dart';

/// Trimmed real `NewPipeCLI --streams` output (stream URLs replaced).
Map<String, dynamic> fixture() =>
    jsonDecode(File('test/fixtures/video_info.json').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('parses a full NewPipeCLI response', () {
    final info = VideoInfo.fromJson(fixture());

    expect(info.id, 'RgA12gkdIvo');
    expect(info.uploadDate, isNotNull);
    expect(info.description?.content, 'desc');
    expect(info.videoStreams, hasLength(1));
  });

  test('parses a reduced response without the descriptive fields', () {
    // YouTube sometimes omits these; they used to throw
    // "type 'Null' is not a subtype of type 'Map<String, dynamic>'".
    const optional = [
      'uploadDate', 'textualUploadDate', 'description', 'viewCount',
      'likeCount', 'dislikeCount', 'uploaderName', 'uploaderUrl',
      'uploaderAvatars', 'uploaderVerified', 'uploaderSubscriberCount',
      'subChannelName', 'subChannelUrl', 'subChannelAvatars', 'thumbnails',
      'audioStreams', 'videoOnlyStreams', 'dashMpdUrl', 'hlsUrl',
      'startPosition', 'category', 'licence', 'supportInfo', 'tags',
      'shortFormContent', 'ageLimit', 'duration',
    ];
    final json = fixture()..removeWhere((key, _) => optional.contains(key));

    final info = VideoInfo.fromJson(json);

    expect(info.uploadDate, isNull);
    expect(info.description, isNull);
    expect(info.viewCount, 0);
    expect(info.tags, isEmpty);
    expect(info.audioStreams, isEmpty);
    expect(info.videoStreams, hasLength(1), reason: 'streams are still parsed');
  });

  test('accepts explicit nulls', () {
    final json = fixture()
      ..['uploadDate'] = null
      ..['description'] = null
      ..['likeCount'] = null;

    final info = VideoInfo.fromJson(json);

    expect(info.uploadDate, isNull);
    expect(info.description, isNull);
    expect(info.likeCount, 0);
  });
}
