import 'dart:convert';
import 'dart:io';

import 'package:flutter_new_pipe_extractor/flutter_new_pipe_extractor.dart';
import 'package:flutter_new_pipe_extractor/src/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses YouTube Music song results without uploaderUrl', () {
    // Real NewPipeCLI --search "THE END OF US PAVÉ" --content-filters music_songs;
    // some songs (artists without a YouTube channel) have no uploaderUrl, which
    // used to throw "type 'Null' is not a subtype of type 'String'".
    final items =
        jsonDecode(File('test/fixtures/search_music_songs.json').readAsStringSync()) as List;
    final streams = items.where((e) => e['infoType'] == 'STREAM').toList();
    expect(streams.where((e) => e['uploaderUrl'] == null), isNotEmpty);

    final parsed = streams
        .map((e) => VideoSearchResultItem.fromJson(deepCastMap(e as Map)))
        .toList();

    expect(parsed, hasLength(streams.length));
    expect(parsed.first.name, 'THE END OF US');
    expect(parsed.first.uploaderName, 'PAVÉ');
    expect(parsed.where((p) => p.uploaderUrl.isEmpty), isNotEmpty);
  });
}
