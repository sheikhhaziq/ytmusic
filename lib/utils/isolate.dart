import 'dart:async';
import 'dart:isolate';

Future<R> runInIsolate<Q, R>(
  FutureOr<R> Function(Q message) function,
  Q message,
) async {
  final responsePort = ReceivePort();

  await Isolate.spawn<_IsolateMessage<Q, R>>(
    _isolateEntry<Q, R>,
    _IsolateMessage(function, message, responsePort.sendPort),
  );

  return await responsePort.first as R;
}

class _IsolateMessage<Q, R> {
  final FutureOr<R> Function(Q) function;
  final Q message;
  final SendPort sendPort;

  _IsolateMessage(this.function, this.message, this.sendPort);
}

void _isolateEntry<Q, R>(_IsolateMessage<Q, R> message) async {
  final result = await message.function(message.message);
  message.sendPort.send(result);
}
