import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class EpheAssets {
  static Future<Directory> ensureEpheDir() async {
    final dir = await getApplicationSupportDirectory();
    final epheDir = Directory('${dir.path}/ephe');
    if (!await epheDir.exists()) {
      await epheDir.create(recursive: true);
    }
    return epheDir;
  }

  static Future<void> copyIfMissing(List<String> assetFiles) async {
    final epheDir = await ensureEpheDir();

    for (final file in assetFiles) {
      final target = File('${epheDir.path}/$file');
      if (await target.exists()) continue;

      try {
        final bytes = await rootBundle.load('assets/ephe/$file');
        await target.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
        debugPrint('Copiado asset: $file');
      } catch (e) {
        // Se o ficheiro não existe nos assets, ignoramos.
        // O C wrapper usará o fallback Moshier.
        debugPrint('Aviso: Asset $file não encontrado em assets/ephe/. Ignorando.');
      }
    }
  }
}