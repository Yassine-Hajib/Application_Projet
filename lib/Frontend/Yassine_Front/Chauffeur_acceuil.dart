import 'package:flutter/material.dart';

// This is the main homepage for the chauffeur after logging in.
// It displays client offers for trips, allowing the chauffeur to accept or decline them.
// Additional functionalities include viewing accepted trips, profile, and earnings.

class ChauffeurHomePage extends StatefulWidget {
  @override
  _ChauffeurHomePageState createState() => _ChauffeurHomePageState();
}

class _ChauffeurHomePageState extends State<ChauffeurHomePage> {
  // Mock data for trip offers. In a real app, this would come from an API or database.
  // Each offer includes details like client name, trip details, and status.
  List<Map<String, dynamic>> tripOffers = [
    {
      'id': 1,
      'clientName': 'John Doe',
      'tripDetails': 'From Hotel to Stade de Marrakech for CAN 2025 match',
      'date': '2025-01-15',
      'status': 'pending', // pending, accepted, declined
    },
    {
      'id': 2,
      'clientName': 'Jane Smith',
      'tripDetails': 'Airport pickup to Hotel in Casablanca',
      'date': '2025-01-16',
      'status': 'pending',
    },
    // Add more mock offers as needed
  ];

  // Mock data for accepted trips (for additional functionality)
  List<Map<String, dynamic>> acceptedTrips = [
    {
      'id': 3,
      'clientName': 'Alice Johnson',
      'tripDetails': 'Stade to Airport',
      'date': '2025-01-14',
      'status': 'completed',
    },
  ];

  // Mock earnings data
  double totalEarnings = 1250.0; // In MAD or whatever currency

  // Function to accept an offer
  void acceptOffer(int offerId) {
    setState(() {
      // Find the offer and update its status
      var offer = tripOffers.firstWhere((o) => o['id'] == offerId);
      offer['status'] = 'accepted';
      // In a real app, send this to the backend
    });
    // Show a snackbar for feedback
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Offer accepted!')));
  }

  // Function to decline an offer
  void declineOffer(int offerId) {
    setState(() {
      var offer = tripOffers.firstWhere((o) => o['id'] == offerId);
      offer['status'] = 'declined';
      // In a real app, send this to the backend
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Offer declined.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chauffeur Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications page (placeholder)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Navigate to profile page (placeholder)
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile page coming soon!')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('My Vehicles'),
              onTap: () {
                // Navigate to vehicles page (placeholder)
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vehicles page coming soon!')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Earnings'),
              onTap: () {
                // Show earnings dialog
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Total Earnings'),
                    content: Text(
                      'You have earned ${totalEarnings} MAD this month.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle logout (placeholder)
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Logged out!')));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section for trip offers
            Text(
              'Trip Offers',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tripOffers.length,
                itemBuilder: (context, index) {
                  var offer = tripOffers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client: ${offer['clientName']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Details: ${offer['tripDetails']}'),
                          Text('Date: ${offer['date']}'),
                          Text('Status: ${offer['status']}'),
                          SizedBox(height: 10),
                          if (offer['status'] == 'pending')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () => acceptOffer(offer['id']),
                                  child: Text('Accept'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () => declineOffer(offer['id']),
                                  child: Text('Decline'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Additional section for accepted trips
            SizedBox(height: 20),
            Text(
              'Accepted Trips',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: acceptedTrips.length,
                itemBuilder: (context, index) {
                  var trip = acceptedTrips[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client: ${trip['clientName']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Details: ${trip['tripDetails']}'),
                          Text('Date: ${trip['date']}'),
                          Text('Status: ${trip['status']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
