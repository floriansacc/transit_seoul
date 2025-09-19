enum FirebaseCollection {
  busId('BusId'),
  routeInfoItem('RouteInfoItem'),
  routePathList('RoutePathList'),
  subwayStation('SubwayStation'),
  stationsByRouteList('StationsByRouteList');

  const FirebaseCollection(this.title);

  final String title;
}
