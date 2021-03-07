import 'dart:async';
int val = 1;
final eventSource = Stream.periodic(Duration(seconds: 1), (_) => val++);

Stream<int> eventEmitter() async* {
  print("enter emitter");
  final controller = StreamController<int>.broadcast();
  StreamSubscription sub;
  try {
    sub=eventSource.listen(controller.add);
    yield* controller.stream;
  } finally {
    print("after yield cleanup!");
    sub.cancel();
    controller.close();
  }
}

Stream<int> transformAsync(Stream<int> stream) async* {
  try{
  await for (final value in stream) {
    print("pre yield");
    yield value + 1;
    print("post yield");
  }
  }catch(e){
    yield 0;
  }
}

Stream<int> transformAsync2(Stream<int> stream) {
  return stream.map((value) => value + 1);
}

void main() async {
 
  
  final subscription = transformAsync2(eventEmitter()).listen((v) {print("got $v");});
  await Future.delayed(Duration(milliseconds: 1500));
  print("cancel sub");
  subscription.cancel();
  await Future.delayed(Duration(milliseconds: 1000));
}
