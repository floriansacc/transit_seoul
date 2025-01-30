enum RouteEnum {
  home('/home'),
  metro('/metro'),
  map('/map'),

  busInfo('/bus-info'),
  busAroundMe('/bus-around-me'),

  settings('/settings'),
  ;

  const RouteEnum(this.path);

  final String path;
}
