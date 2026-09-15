part of 'parking_bloc.dart';

sealed class ParkingEvent extends Equatable {
  const ParkingEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class ParkingRequested extends ParkingEvent {
  const ParkingRequested();
}

class ParkingStarted extends ParkingEvent {
  const ParkingStarted({required this.bayCode});

  final String bayCode;

  @override
  List<Object?> get props => <Object?>[bayCode];
}

class ParkingStopped extends ParkingEvent {
  const ParkingStopped();
}
