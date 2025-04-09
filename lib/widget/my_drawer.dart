import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kichukini/authScreen/auth_screen.dart';
import 'package:kichukini/global/global.dart';
import 'package:kichukini/mainScreen/my_order_screen.dart';
import 'package:kichukini/splashScreen/my_splash_screen.dart';
import 'package:kichukini/widget/map_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String _locationStatus = "Tap to get location";
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  void _loadSavedLocation() {
    double? lat = sharedPreferences?.getDouble("lat");
    double? lng = sharedPreferences?.getDouble("lng");

    if (lat != null && lng != null) {
      setState(() {
        _locationStatus =
            "Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}";
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
      _locationStatus = "Fetching location...";
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationStatus = "Location services are disabled";
          _isFetchingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationStatus = "Location permission denied";
            _isFetchingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationStatus = "Permission permanently denied";
          _isFetchingLocation = false;
        });
        return;
      }

      // ✅ Get the most accurate, fresh current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );

      // Save to shared preferences
      sharedPreferences?.setDouble("lat", position.latitude);
      sharedPreferences?.setDouble("lng", position.longitude);

      setState(() {
        _locationStatus =
            "Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}";
        _isFetchingLocation = false;
      });
    } catch (e) {
      setState(() {
        _locationStatus = "Error getting location: ${e.toString()}";
        _isFetchingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black54,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 26, bottom: 12),
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      sharedPreferences?.getString("photoUrl") ??
                          "https://example.com/default_profile.png",
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  sharedPreferences?.getString("name") ?? "Guest User",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 10, color: Colors.grey, thickness: 2),

          // 📍 Get Current Location
          ListTile(
            leading: _isFetchingLocation
                ? const CircularProgressIndicator(color: Colors.grey)
                : const Icon(Icons.location_on, color: Colors.grey),
            title: Text(
              _locationStatus,
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: _getCurrentLocation,
          ),
          const Divider(height: 10, color: Colors.grey, thickness: 2),

          // 🗺 View on Map
          ListTile(
            leading: const Icon(Icons.map, color: Colors.grey),
            title:
                const Text("View on Map", style: TextStyle(color: Colors.grey)),
            onTap: () {
              double? lat = sharedPreferences?.getDouble("lat");
              double? lng = sharedPreferences?.getDouble("lng");

              if (lat != null && lng != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MapScreen(latitude: lat, longitude: lng),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No location saved")),
                );
              }
            },
          ),
          const Divider(height: 10, color: Colors.grey, thickness: 2),

          // 🏠 Home
          ListTile(
            leading: const Icon(Icons.home, color: Colors.grey),
            title: const Text("Home", style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(height: 10, color: Colors.grey, thickness: 2),

          // 📦 My Orders
          ListTile(
            leading: const Icon(Icons.reorder, color: Colors.grey),
            title:
                const Text("My Orders", style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyOrdersScreen()),
              );
            },
          ),
          const Divider(height: 10, color: Colors.grey, thickness: 2),

          // 🚪 Logout
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.grey),
            title: const Text("Logout", style: TextStyle(color: Colors.grey)),
            onTap: () {
              sharedPreferences?.remove("lat");
              sharedPreferences?.remove("lng");
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (c) => const MySplashScreen()),
              );
            },
          ),
          const Divider(height: 10, color: Colors.grey, thickness: 2),
        ],
      ),
    );
  }
}
