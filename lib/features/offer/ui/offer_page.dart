import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/offer/model/offer_model.dart';
import 'package:flutter_application_1/features/ask_a_question/ui/ask_a_question_page.dart';

class OfferPage extends StatelessWidget {
  final Offer offer;

  const OfferPage({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offer Details'),
        backgroundColor: Color(0xFFFF9933),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Offer Details Container
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  offer.imageData != null
                      ? Image.memory(
                          offer.imageData!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Placeholder(
                          fallbackHeight: 100,
                          fallbackWidth: 100,
                        ),
                  SizedBox(width: 16),
                  // Details Section
                  Expanded(
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
            ),
            SizedBox(height: 20),
            Text(
              'Details Table',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8.0),
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
              child: DataTable(
                columnSpacing: 16,
                headingRowHeight: 56,
                dataRowHeight: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                columns: const [
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Title',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'No. of Questions',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Action',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text('Horoscope')),
                      DataCell(Text('${offer.horoscopeQuestionCount ?? 0}')),
                      DataCell(
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AskQuestion(),
                              ),
                            );
                          },
                          child: Text('Choose'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Compatibility')),
                      DataCell(Text('${offer.compatibilityQuestionCount ?? 0}')),
                      DataCell(
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AskQuestion(),
                              ),
                            );
                          },
                          child: Text('Choose'),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Auspicious')),
                      DataCell(Text('1')), // Assuming there's one question for auspicious
                      DataCell(
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AskQuestion(),
                              ),
                            );
                          },
                          child: Text('Choose'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
