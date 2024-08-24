import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/offer/model/offer_model.dart';
import 'package:flutter_application_1/features/offer/ui/offer_page.dart';

class OfferWidget extends StatelessWidget {
  final Offer offer;

  const OfferWidget({required this.offer});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OfferPage(offer: offer)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
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
            // Header with name and price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    offer.name ?? 'No Name Available',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle overflow
                  ),
                ),
                Text(
                  '\$${offer.price?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05, // Responsive font size
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Image container
            offer.imageData != null
                ? Image.memory(
                    offer.imageData!,
                    width: screenWidth * 0.8, // Full width
                    height: screenHeight * 0.12, // Responsive height
                    fit: BoxFit.cover,
                  )
                : Placeholder(
                    fallbackHeight: screenHeight * 0.12, // Responsive height
                    fallbackWidth: screenWidth * 0.8, // Full width
                  ),
            SizedBox(height: 8),
            // Side-by-side counts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Horoscope Questions: ${offer.horoscopeQuestionCount ?? 0}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03, // Responsive font size
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Compatibility Questions: ${offer.compatibilityQuestionCount ?? 0}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03, // Responsive font size
                    ),
                    textAlign: TextAlign.right, // Align text to the right
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            // Auspicious Question ID
            Text(
              'Auspicious Question ID: ${offer.auspiciousQuestionId ?? 'N/A'}',
              style: TextStyle(
                fontSize: screenWidth * 0.03, // Responsive font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
