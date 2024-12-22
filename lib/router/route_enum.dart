enum RouteEnum {
  home('/home'),
  map('/map'),

  settings('/settings'),
  ;

  const RouteEnum(this.path);

  final String path;
}
