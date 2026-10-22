import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  final int activeCarouselIndex;
  final bool isValuePropsExpanded;

  const OnboardingState({
    this.activeCarouselIndex = 0,
    this.isValuePropsExpanded = false,
  });

  OnboardingState copyWith({
    int? activeCarouselIndex,
    bool? isValuePropsExpanded,
  }) {
    return OnboardingState(
      activeCarouselIndex: activeCarouselIndex ?? this.activeCarouselIndex,
      isValuePropsExpanded: isValuePropsExpanded ?? this.isValuePropsExpanded,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void setCarouselIndex(int index) {
    state = state.copyWith(activeCarouselIndex: index);
  }

  void toggleValuePropsExpanded() {
    state = state.copyWith(
      isValuePropsExpanded: !state.isValuePropsExpanded,
    );
  }

  void setValuePropsExpanded(bool value) {
    state = state.copyWith(isValuePropsExpanded: value);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});
