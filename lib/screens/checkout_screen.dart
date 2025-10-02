
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  final VoidCallback onBack;
  final int totalAmount;
  final List<Map<String, dynamic>> items;

  const CheckoutScreen({
    Key? key,
    required this.onBack,
    required this.totalAmount,
    required this.items,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

enum PaymentMethod { airtel, mpamba, card, bank }

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod selectedPayment = PaymentMethod.airtel;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  bool showSuccess = false;
  final NumberFormat currencyFormat = NumberFormat('#,##0', 'en_US');

  void handlePayment() {
    setState(() {
      showSuccess = true;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showSuccess = false;
      });
      widget.onBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSuccess) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade50, Colors.green.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle, size: 48, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Payment Successful!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                ),
                SizedBox(height: 8),
                Text(
                  'Your payment of MWK ${currencyFormat.format(widget.totalAmount)} has been processed',
                  style: TextStyle(color: Colors.green.shade700),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Transaction ID: TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  style: TextStyle(color: Colors.green.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header & Order Summary
            Container(
              padding: EdgeInsets.fromLTRB(24, 60, 24, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.teal, Colors.blue]),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: widget.onBack,
                      ),
                      SizedBox(width: 8),
                      Text('Secure Checkout', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Amount', style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 4),
                        Text(
                          'MWK ${currencyFormat.format(widget.totalAmount)}',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text('${widget.items.length} item(s) • Secure payment', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Methods
                  Text('Choose Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Column(
                    children: PaymentMethod.values.map((method) {
                      Color bgColor;
                      String title;
                      String description;

                      switch (method) {
                        case PaymentMethod.airtel:
                          bgColor = Colors.red;
                          title = 'Airtel Money';
                          description = 'Pay with Airtel Money';
                          break;
                        case PaymentMethod.mpamba:
                          bgColor = Colors.blue;
                          title = 'TNM Mpamba';
                          description = 'Pay with TNM Mpamba';
                          break;
                        case PaymentMethod.card:
                          bgColor = Colors.purple;
                          title = 'Debit/Credit Card';
                          description = 'Visa, Mastercard accepted';
                          break;
                        case PaymentMethod.bank:
                          bgColor = Colors.green;
                          title = 'Bank Transfer';
                          description = 'Direct bank transfer';
                          break;
                      }

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPayment = method;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selectedPayment == method ? bgColor.withOpacity(0.1) : Colors.white,
                            border: Border.all(color: selectedPayment == method ? Colors.teal : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: bgColor,
                                child: Icon(
                                  method == PaymentMethod.card ? Icons.credit_card : Icons.smartphone,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                ],
                              ),
                              Spacer(),
                              if (selectedPayment == method)
                                Icon(Icons.check_circle, color: Colors.teal),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  // Payment Details
                  if (selectedPayment == PaymentMethod.airtel || selectedPayment == PaymentMethod.mpamba)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '0881 234 567',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue),
                              SizedBox(width: 8),
                              Expanded(child: Text('You will receive a prompt on your phone to complete the payment.', style: TextStyle(fontSize: 12))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (selectedPayment == PaymentMethod.card)
                    Column(
                      children: [
                        Text('Card Number', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        TextField(
                          controller: cardController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '1234 5678 9012 3456',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Expiry Date', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  TextField(
                                    controller: expiryController,
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                      hintText: 'MM/YY',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('CVV', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  TextField(
                                    controller: cvvController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '123',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (selectedPayment == PaymentMethod.bank)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bank Transfer Details', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade800)),
                          SizedBox(height: 4),
                          Text('Account Name: NdalaFlow Payments', style: TextStyle(fontSize: 12)),
                          Text('Account Number: 1234567890', style: TextStyle(fontSize: 12)),
                          Text('Bank: National Bank of Malawi', style: TextStyle(fontSize: 12)),
                          Text('Reference: ORDER${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  SizedBox(height: 16),
                  // Pay Button
                  ElevatedButton(
                    onPressed: ((selectedPayment == PaymentMethod.airtel || selectedPayment == PaymentMethod.mpamba) && phoneController.text.isEmpty) ||
                            (selectedPayment == PaymentMethod.card &&
                                (cardController.text.isEmpty || expiryController.text.isEmpty || cvvController.text.isEmpty))
                        ? null
                        : handlePayment,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text('Pay MWK ${currencyFormat.format(widget.totalAmount)}'),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
