import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/offer/model/offer_model.dart';
import 'package:flutter_application_1/features/offer/ui/offer_page.dart';

class OfferWidget extends StatelessWidget {
  final Offer offer;

  const OfferWidget({required this.offer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OfferPage(offer: offer)),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFF9933).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offer.name ?? 'No Name Available',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$${offer.price?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                offer.imageData != null
                    ? Image.memory(
                        offer.imageData!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Placeholder(fallbackHeight: 100, fallbackWidth: 100),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.description ?? 'No Description Available',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Horoscope Questions: ${offer.horoscopeQuestionCount ?? 0}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Compatibility Questions: ${offer.compatibilityQuestionCount ?? 0}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Auspicious Question ID: ${offer.auspiciousQuestionId ?? 'N/A'}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
