import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/telemetry_model.dart';

class SplashState {
  final int currentIndex;
  final List<TelemetryModel> telemetryList;

  const SplashState({
    this.currentIndex = 0,
    this.telemetryList = const [
      TelemetryModel(
        step: 1,
        message: 'Securing statutory cryptographic conduit...',
      ),
      // TelemetryModel(step: 2, message: 'Validating RBI Master Directions...'),
      // TelemetryModel(step: 3, message: 'Synchronizing Tokenized Debt Portfolios...'),
      TelemetryModel(step: 2, message: 'Establishing Encrypted Enclave...'),
    ],
  });

  String get currentMessage => telemetryList.isNotEmpty
      ? telemetryList[currentIndex % telemetryList.length].message
      : '';

  SplashState copyWith({
    int? currentIndex,
    List<TelemetryModel>? telemetryList,
  }) {
    return SplashState(
      currentIndex: currentIndex ?? this.currentIndex,
      telemetryList: telemetryList ?? this.telemetryList,
    );
  }
}

class SplashNotifier extends StateNotifier<SplashState> {
  SplashNotifier() : super(const SplashState());

  void advanceTelemetry() {
    state = state.copyWith(
      currentIndex: (state.currentIndex + 1) % state.telemetryList.length,
    );
  }

  void reset() {
    state = const SplashState();
  }
}

final splashProvider = StateNotifierProvider<SplashNotifier, SplashState>((
  ref,
) {
  return SplashNotifier();
});
