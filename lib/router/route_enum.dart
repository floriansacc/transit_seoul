enum RouteEnum {
  home('/home'),
  map('/map'),

  busInfo('/bus-info'),

  settings('/settings'),
  ;

  const RouteEnum(this.path);

  final String path;
}
