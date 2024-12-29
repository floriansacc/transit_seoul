enum FirebaseCollection {
  busId('BusId'),
  routeInfoItem('RouteInfoItem'),
  routePathList('RoutePathList'),
  stationsByRouteList('StationsByRouteList');

  const FirebaseCollection(this.title);

  final String title;
}
