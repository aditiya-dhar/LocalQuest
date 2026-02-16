import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:animations/animations.dart';

import '../models/quest.dart';
import '../models/friend.dart';
import '../services/location_service.dart';
import '../services/routing_service.dart';
import 'profile_screen.dart';
import 'leaderboard_screen.dart';
import 'about_screen.dart';
import '../widgets/menu_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final locationService = LocationService();
  final routingService = RoutingService();
  final MapController mapController = MapController();

  LatLng? userLocation;
  List<LatLng> routePoints = [];

  bool menuOpen = false;
  bool showBottomBubble = false;

  late final List<Quest> Quests;
  late final List<Friend> friends;

  late AnimationController menuAnimController;
  late AnimationController bubbleAnimController;

  final List<MapStyle> mapStyles = [
    MapStyle(
        name: 'Light',
        url:
            'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png'),
    MapStyle(
        name: 'Standard',
        url: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
    MapStyle(
        name: 'Topographic',
        url: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png'),
  ];

  int currentMapStyleIndex = 0;

  @override
  void initState() {
    super.initState();
    menuAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    bubbleAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _init();
  }

  @override
  void dispose() {
    menuAnimController.dispose();
    bubbleAnimController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    Quests = [
      // Solo Quest - only user
      Quest(
        title: "Coffee Shop",
        lat: 39.9850,
        lng: -75.1670,
        radius: 1500,
        participants: ["You"],
      ),
      // Group Quest - user and Alex
      Quest(
        title: "Park Cleanup",
        lat: 39.9780,
        lng: -75.1690,
        radius: 1500,
        participants: ["You", "Alex"],
      ),
      // Group Quest - user, Alex, and Sam
      Quest(
        title: "Temple Library",
        lat: 39.9829,
        lng: -75.1689,
        radius: 1500,
        participants: ["You", "Alex", "Sam"],
      ),
    ];
    friends = [
      Friend(name: "Alex", lat: 39.9860, lng: -75.1680),
      Friend(name: "Sam", lat: 39.9810, lng: -75.1700),
    ];
    final pos = await locationService.getLocation();
    setState(() => userLocation = LatLng(pos.latitude, pos.longitude));
  }

  double distance(LatLng a, LatLng b) =>
      const Distance().as(LengthUnit.Meter, a, b);

  Future<void> _selectQuest(Quest Quest) async {

    if (userLocation == null) return;

    setState(() => routePoints = []);

    final route = await routingService.getRoute(
      userLocation!.latitude,
      userLocation!.longitude,
      Quest.lat,
      Quest.lng,
    );

    if (route.isEmpty) return; // stop if no route

    setState(() => routePoints = route);

    // Move map to midpoint or start of route
    final midIndex = (route.length / 2).floor();
    mapController.move(route[midIndex], 16.0);
  }

  void _toggleMenu() => setState(() => menuOpen = !menuOpen);

  void _toggleBottomBubble() {
    setState(() => showBottomBubble = !showBottomBubble);
    if (showBottomBubble) {
      bubbleAnimController.forward();
    } else {
      bubbleAnimController.reverse();
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) =>
            FadeTransition(opacity: animation, child: screen),
      ),
    );
    setState(() => menuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final nearbyQuests = Quests;
        // .where((t) => distance(userLocation!, LatLng(t.lat, t.lng)) <= t.radius)
        // .toList();

    final List<Marker> markers = [
      // User location marker
      Marker(
        point: userLocation!,
        width: 40,
        height: 40,
        child: const Icon(
          Icons.my_location,
          color: Colors.blue,
          size: 32,
        ),
      ),

      // Friends markers
      ...friends.map((f) => Marker(
            point: LatLng(f.lat, f.lng),
            width: 40,
            height: 40,
            child: const Icon(
              Icons.person_pin_circle,
              color: Colors.red,
              size: 32,
            ),
          )),

      // Nearby Quests markers
      ...nearbyQuests.map((t) => Marker(
            point: LatLng(t.lat, t.lng),
            width: 40,
            height: 40,
            child: OpenContainer(
              closedColor: Colors.transparent,
              openColor: Colors.white,
              closedBuilder:
                  (BuildContext context, VoidCallback openContainer) {
                return GestureDetector(
                  onTap: openContainer,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(Icons.flag, color: Colors.white),
                  ),
                );
              },
              openBuilder: (BuildContext context, VoidCallback _) {
                return Scaffold(
                  appBar: AppBar(title: Text(t.title)),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Participants: ${t.participants.join(", ")}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => _selectQuest(t),
                          icon: const Icon(Icons.navigation),
                          label: const Text("Get Directions"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )),
    ];

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: userLocation!,
              initialZoom: 16,
              maxZoom: 19,
            ),
            children: [
              TileLayer(
                urlTemplate: mapStyles[currentMapStyleIndex].url,
                userAgentPackageName: 'com.example.localquest',
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  markers: markers,
                  maxClusterRadius: 60,
                  size: const Size(40, 40),
                  builder: (context, clusterMarkers) => Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
                    child: Text('${clusterMarkers.length}',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      color: Colors.blue,
                      strokeWidth: 4,
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
              top: 16,
              left: 16,
              child: MenuButton(onTap: _toggleMenu, anim: menuAnimController)),
          if (menuOpen)
            Positioned(
              top: 80,
              left: 16,
              child: Column(
                children: [
                  _buildMenuItem(
                    Icons.person,
                    "Profile",
                    Colors.purple,
                    const ProfileScreen(),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    Icons.leaderboard,
                    "Leaderboard",
                    Colors.orange,
                    const LeaderboardScreen(),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    Icons.info_outline,
                    "About",
                    Colors.teal,
                    const AboutScreen(),
                  ),
                ],
              ),
            ),
          Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton.small(
                  onPressed: _showMapStyleDialog,
                  child: const Icon(Icons.layers))),
          Positioned(
            bottom: 80,
            right: 16,
            child: FloatingActionButton(
              onPressed: _toggleBottomBubble,
              child: const Icon(Icons.chat_bubble_outline),
            ),
          ),
          if (showBottomBubble)
            AnimatedBuilder(
              animation: bubbleAnimController,
              builder: (context, child) => Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: bubbleAnimController,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: child!,
                ),
              ),
              child: _buildBottomBubble(nearbyQuests),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBubble(List<Quest> nearbyQuests) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quick Info',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _toggleBottomBubble,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (nearbyQuests.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nearby Quests:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...nearbyQuests.map((t) => GestureDetector(
                      onTap: () => _selectQuest(t),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(t.title,
                            style: const TextStyle(color: Colors.green)),
                      ),
                    )),
              ],
            ),
          const SizedBox(height: 8),
          if (friends.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Friends:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...friends.map((f) => GestureDetector(
                      onTap: () => mapController.move(LatLng(f.lat, f.lng), 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(f.name,
                            style: const TextStyle(color: Colors.red)),
                      ),
                    )),
              ],
            ),
          const SizedBox(height: 8),
          Text('Total Quests: ${Quests.length}',
              style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label,
    Color color,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () => _navigateTo(screen),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showMapStyleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Map Style'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            mapStyles.length,
            (index) => ListTile(
              title: Text(mapStyles[index].name),
              onTap: () {
                setState(() => currentMapStyleIndex = index);
                Navigator.pop(context);
              },
              selected: currentMapStyleIndex == index,
            ),
          ),
        ),
      ),
    );
  }
}

class MapStyle {
  final String name;
  final String url;
  MapStyle({required this.name, required this.url});
}
