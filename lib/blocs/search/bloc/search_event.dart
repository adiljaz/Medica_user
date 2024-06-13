abstract class SearchEvent {}

class SearchDoctorsEvent extends SearchEvent {
  final String query;

  SearchDoctorsEvent(this.query);
}
