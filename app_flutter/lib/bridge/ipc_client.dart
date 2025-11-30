import 'dart:io';
import 'dart:async';

class IpcClient {
  final String pipeName;
  RandomAccessFile? _pipe;
  bool _connected = false;

  IpcClient({required this.pipeName});

  Future<void> connect() async {
    while (!_connected) {
      try {
        // On Windows, named pipes are files
        final path = '\\\\.\\pipe\\$pipeName';
        _pipe = await File(path).open(mode: FileMode.write);
        _connected = true;
        print('Connected to pipe: $pipeName');
      } catch (e) {
        print('Waiting for pipe... $e');
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  void send(String message) {
    if (_connected && _pipe != null) {
      try {
        _pipe!.writeStringSync(message);
        _pipe!.flushSync();
      } catch (e) {
        print('Error sending message: $e');
        _connected = false;
        _pipe?.close();
      }
    }
  }

  void dispose() {
    _pipe?.close();
  }
}
