import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/services.dart';
import 'package:flutter_new_pipe_extractor/src/pigeon/newpipe_api.g.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const platformFileNames = {
  "linux-x64": "NewPipeCLI-linux-x64.zip",
  "linux-arm64": "NewPipeCLI-linux-arm64.zip",
  "windows-x64": "NewPipeCLI-windows-x64.zip",
  "macos": "NewPipeCLI-macos-universal.zip",
};

class NewPipeDesktopApiImpl implements NewPipeExtractor {
  File? executableFile;

  @override
  Future<void> init() async {
    assert(executableFile == null, "Already initialized");

    final appSupportDir = await getApplicationSupportDirectory();
    await appSupportDir.create(recursive: true);
    final binaryName = Platform.isWindows ? 'NewPipeCLI.exe' : 'NewPipeCLI';

    final destBinary = File(join(appSupportDir.path, binaryName));

    final arch = Platform.isMacOS || Platform.isIOS
        ? ""
        : Platform.version.contains(RegExp("x64|x86_64"))
            ? "-x64"
            : "-arm64";
    final zipName =
        platformFileNames["${Platform.operatingSystem}$arch"] as String;
    final bytes = await rootBundle
        .load('packages/flutter_new_pipe_extractor/assets/$zipName');

    // Only the zip's index is read here, the binary is inflated on demand
    final archive = ZipDecoder().decodeBytes(bytes.buffer.asUint8List());
    final entry = archive.findFile(binaryName);
    if (entry == null) throw Exception("$binaryName not found in $zipName");

    // Rewriting the binary on every start delays the app's window (28 MB on
    // Windows, scanned again by the antivirus each time): keep the extracted
    // copy while it's the bundled one
    final stamp = File("${destBinary.path}.version");
    final bundledVersion = "${entry.crc32}:${entry.size}";
    if (await destBinary.exists() &&
        await stamp.exists() &&
        await stamp.readAsString() == bundledVersion) {
      executableFile = destBinary;
      return;
    }

    await destBinary.writeAsBytes(entry.content, flush: true);

    if (!Platform.isWindows) {
      await Process.run('chmod', ['+x', destBinary.path]);
    }

    await stamp.writeAsString(bundledVersion);

    executableFile = destBinary;
  }

  Future<String> executeString(List<String> args) async {
    if (executableFile == null) throw Exception("Not initialized");

    final result = await Process.run(
      executableFile!.path,
      args,
      // runInShell: true,
      // NewPipeCLI may create temp files, so we set the working directory to a writable temp dir
      workingDirectory: Directory.systemTemp.path,
      // NewPipeCLI writes UTF-8; the default (systemEncoding) is a legacy code
      // page on Windows and garbled non-ASCII names ("RÃœFÃœS DU SOL")
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );

    final stdOut = result.stdout.toString();
    final stdErr = result.stderr.toString();

    if (stdErr.isNotEmpty && stdOut.isEmpty) {
      throw Exception(
        "NewPipeCLI command failed with exit code ${result.exitCode}\n"
        "STDOUT: $stdOut\n"
        "STDERR: $stdErr",
      );
    }

    return stdOut;
  }

  @override
  // ignore: non_constant_identifier_names
  BinaryMessenger? get pigeonVar_binaryMessenger => null;

  @override
  // ignore: non_constant_identifier_names
  String get pigeonVar_messageChannelSuffix => "";

  @override
  Future<JsonMessageMap> getVideoInfo(String videoId) async {
    final res = await executeString([
      "--streams",
      videoId,
    ]);

    return JsonMessageMap.decode([jsonDecode(res)]);
  }

  @override
  Future<List<JsonMessageMap>> search(
    String query, {
    List<String>? contentFilters,
    String? sortFilter,
  }) async {
    final res = await executeString([
      // Base64 of the UTF-8 query: on Windows non-ASCII characters in command
      // line arguments arrived as '?' ("PAVÉ" -> "PAV?") and the search
      // returned unrelated results. Needs NewPipeCLI >= 0.1.4 (fork).
      "--search-b64",
      base64Encode(utf8.encode(query)),
      if (contentFilters != null) ...[
        "--content-filters",
        contentFilters.join(","),
      ],
      if (sortFilter != null) ...[
        "--sort-filter",
        sortFilter,
      ],
    ]);

    final decoded = jsonDecode(res) as List;

    return decoded.map((e) => JsonMessageMap.decode([e])).toList();
  }
}
