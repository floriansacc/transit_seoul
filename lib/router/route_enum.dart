enum RouteEnum {
  home('/home'),
  metro('/metro'),
  map('/map'),

  busInfo('/bus-info'),

  settings('/settings'),
  ;

  const RouteEnum(this.path);

  final String path;
}
