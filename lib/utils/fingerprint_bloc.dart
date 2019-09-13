import 'package:rxdart/rxdart.dart';

class FingerPrintBloc {
  final controller = BehaviorSubject<bool>();
  get stream => controller.stream;

  void setTouchId(bool b) {
    controller.sink.add(b);
  }

  close() {
    controller.close();
  }
}
