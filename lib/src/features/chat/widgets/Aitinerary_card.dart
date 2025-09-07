import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_trip_planner_flutter/src/features/home/models/itinerary_models.dart';
import 'package:url_launcher/url_launcher.dart';

class AiItineraryCard extends StatelessWidget {
  final Itinerary iti;
  const AiItineraryCard({required this.iti});

  Future<void> openMap(String query, BuildContext context) async {
    final encoded = Uri.encodeComponent(query);

    final browserUri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$encoded",
    );

    if (await canLaunchUrl(browserUri)) {
      await launchUrl(browserUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No app found to open Google Maps")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 255, 200, 0),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.chat_bubble, size: 16, color: Colors.white),
                ),
                SizedBox(width: 12),
                Text(
                  'Itinera AI',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              iti.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              '${iti.startDate} — ${iti.endDate}',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),

            // All days
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: iti.days.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, d) {
                final day = iti.days[d];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day ${d + 1}: ${day.summary}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    // All items per day
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: day.items
                          .map(
                            (i) => Text(
                              '• ${i.time}  ${i.activity}  (${i.location})',
                            ),
                          )
                          .toList(),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () => openMap(iti.title, context),
              child: Container(
                alignment: Alignment.centerLeft,
                height: 42,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(33, 122, 91, 0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "📍 Open in maps",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.blue, // to show it's tappable
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
