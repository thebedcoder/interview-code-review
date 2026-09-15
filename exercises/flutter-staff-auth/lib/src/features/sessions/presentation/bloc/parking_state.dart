part of 'parking_bloc.dart';

sealed class ParkingState extends Equatable {
  const ParkingState();

  @override
  List<Object?> get props => <Object?>[];
}

class ParkingInitial extends ParkingState {
  const ParkingInitial();
}

class ParkingLoading extends ParkingState {
  const ParkingLoading();
}

class ParkingIdle extends ParkingState {
  const ParkingIdle();
}

class ParkingActive extends ParkingState {
  const ParkingActive({required this.session});

  final ParkingSession session;

  @override
  List<Object?> get props => <Object?>[session];
}

class ParkingFinished extends ParkingState {
  const ParkingFinished({required this.session});

  final ParkingSession session;

  @override
  List<Object?> get props => <Object?>[session];
}

class ParkingFailure extends ParkingState {
  const ParkingFailure({required this.error});

  final AppException error;

  @override
  List<Object?> get props => <Object?>[error];
}
