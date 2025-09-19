enum RouteEnum {
  app('/'),

  home('/bus'),
  metro('/metro'),
  map('/map'),

  busInfo('/bus/bus-info'),
  busAroundMe('/bus/bus-around-me'),

  my('/my'),
  settings('/settings'),
  ;

  const RouteEnum(this.path);

  final String path;
}
