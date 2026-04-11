import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lifecycle_service.g.dart';

@Riverpod(keepAlive: true)
class LifeCycleService extends _$LifeCycleService {
  @override
  Map<dynamic, dynamic> build() {
    return {
      'point': 5,
      'health': 'Depresi Normal',
      'meditation': false,
      'koleksi_syukur': false,
      'move_detection': false,
      'mind_sorting': false,
      'complete': false,
      'total': 0,
    };
  }

  void updateActivity(String activity) {
    if (state.containsKey(activity)) {
      // Ingat: State di Riverpod itu immutable (tidak boleh diubah langsung).
      // Kita copy state lama, ubah nilainya, lalu jadikan state baru.
      final newState = Map.from(state);
      newState[activity] = !newState[activity]!;
      if (newState['meditation'] == true &&
          newState['koleksi_syukur'] == true &&
          newState['move_detection'] == true &&
          newState['mind_sorting'] == true) {
        newState['complete'] = true;
      } else {
        newState['total'] = newState['total'] + 1;
      }
      state = newState;
    }
  }

  void updateHealth(String health) {
    final newState = Map.from(state);
    newState['health'] = health;
    state = newState;
  }

  void addPoint() {
    final newState = Map.from(state);
    newState['point'] = newState['point'] + 10;
    state = newState;
  }
}
