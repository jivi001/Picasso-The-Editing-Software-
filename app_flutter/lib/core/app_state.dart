enum AppPage {
  media,
  cut,
  edit,
  fusion,
  color,
  audio,
  deliver,
}

class AppState {
  AppPage _currentPage = AppPage.edit;

  AppPage get currentPage => _currentPage;

  void navigateTo(AppPage page) {
    _currentPage = page;
  }
}
