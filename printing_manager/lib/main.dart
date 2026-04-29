import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:fl_chart/fl_chart.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Printing Services',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}


// Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;

  void _showLoginToast(String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: bgColor,
        width: 380, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 6,
        duration: const Duration(seconds: 3),
      )
    );
  }

  // Login function
  Future<void> login() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/printing-services-final/printing_api/login.php'),
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );
      
      // Check if the response is successful
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          _showLoginToast(data['message'], Colors.red[700]!);
        }
      }
    } catch (e) {
      _showLoginToast('Database connection error. Is XAMPP running?', Colors.red[700]!);
    }
  }

// UI for login
  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Login | Printing Services',
      color: Colors.blueGrey,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F8),
        body: Center(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(32),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.print, size: 60, color: Colors.blueGrey[800]),
                  const SizedBox(height: 16),
                  Text(
                    'Printing Services',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: Colors.blueGrey[900]),
                  ),
                  const SizedBox(height: 40),

                  // Username and password fields
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue.shade600, width: 2)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: _isObscure,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) => login(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue.shade600, width: 2)),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.blueGrey[400]),
                        onPressed: () {
                          setState(() { _isObscure = !_isObscure; });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// Dashboard
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List orders = [];
  bool isLoading = true;

  // Google Gemini API Key
  final String apiKey = '';

  @override
  void initState() {
    super.initState();
    fetchOrders(); 
  }

  void _showToast(String message, Color bgColor, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: bgColor,
        width: 320, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 6,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // AI Insights function
  Future<void> showAIInsights() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.purple)),
    );

    // Generate AI insights
    try {
      double estimatedRevenue = 0;
      for (var order in orders) {
        estimatedRevenue += double.tryParse(order['total_price'].toString()) ?? 0.0;
      }
      int pending = orders.where((o) => o['order_status'] == 'Pending').length;

      // A detailed prompt for the AI model
      String prompt = '''
      You are an AI Business Assistant for a Printing Services shop. 
      I have ${orders.length} total orders, with $pending still pending.
      My total expected revenue is ₱$estimatedRevenue.
      Here is my current queue data: $orders

      Please give me a clear, simple 3-sentence summary:
      1. Tell me my total expected revenue and what type of printing is most popular right now.
      2. Identify any large orders that might slow down the printer.
      3. Tell me exactly which specific order I should print next to be the most efficient. Use the Customer's Name (NEVER use order ID numbers), and explain why in plain English.
      ''';
      
      // The AI model will analyze the data and provide insights based on the prompt
      final model = GenerativeModel(model: 'gemini-flash-latest', apiKey: apiKey);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      // Close the loading dialog before showing insights
      Navigator.pop(context);

      // Display the insights in a dialog with a pie chart of the queue
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.purple[600]),
              const SizedBox(width: 10),
              Text('AI Assistant Insights', style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 500, 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  QueuePieChart(orders: orders),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    response.text ?? 'I could not analyze the data right now.', 
                    style: TextStyle(color: Colors.blueGrey[800], fontSize: 14, height: 1.5)
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[600], elevation: 0),
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it!', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context); 
      print("AI ACTUAL ERROR: $e");
      _showToast('Error connecting to AI Assistant.', Colors.red[800]!, Icons.error_outline);
    }
  }

  // Fetch orders from API
  Future<void> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/printing-services-final/printing_api/get_orders.php'));
      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  // Create order function
  Future<void> createOrder(
    String customerName, String serviceType, String documentType, 
    String pageCount, String colorType, String totalPrice, 
    String orderStatus
  ) async {
    var url = Uri.parse('http://localhost/printing-services-final/printing_api/add_order.php'); 
    try {
      var response = await http.post(
        url,
        body: {
          "customer_name": customerName, "service_type": serviceType, "document_type": documentType,
          "page_count": pageCount, "color_type": colorType, "total_price": totalPrice,
          "order_status": orderStatus
        },
      );
      if (response.statusCode == 200) {
        _showToast('Order successfully added', Colors.green[600]!, Icons.check_circle);
        fetchOrders(); 
      }
    } catch (e) {
      print("Failed to connect to server: $e");
    }
  }

  // Update order status function
  Future<void> updateOrderStatus(Map order, String status) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/printing-services-final/printing_api/update_status.php'),
        body: {'order_id': order['order_id'].toString(), 'order_status': status},
      );
      if (response.statusCode == 200) {
        fetchOrders(); 
        _showToast('Order status updated to $status', Colors.blueGrey[800]!, Icons.info_outline);
      }
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  // Delete order function
  Future<void> deleteOrder(String id) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/printing-services-final/printing_api/delete_order.php'),
        body: {'order_id': id},
      );
      if (response.statusCode == 200) {
        fetchOrders();
        _showToast('Order removed', Colors.red[600]!, Icons.delete_outline);
      }
    } catch (e) {
      print("Error deleting order: $e");
    }
  }

  // Helper functions for status colors
  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Pending': return Colors.orange.shade100;
      case 'Printing': return Colors.blue.shade100;
      case 'Done': return Colors.green.shade100;
      default: return Colors.grey.shade100;
    }
  }

  // Helper functions for status text colors
  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Pending': return Colors.orange.shade900;
      case 'Printing': return Colors.blue.shade900;
      case 'Done': return Colors.green.shade900;
      default: return Colors.grey.shade900;
    }
  }

  // Receipt dialog function
  void showReceiptDialog(Map order) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), 
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long, size: 40, color: Colors.blueGrey[900]),
                const SizedBox(height: 12),
                Text('PRINTING SERVICES', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.blueGrey[900])),
                Text('Buhangin, Davao City', style: TextStyle(fontSize: 12, color: Colors.blueGrey[500])),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(thickness: 1, color: Colors.grey.shade300), 
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Customer:', style: TextStyle(color: Colors.blueGrey[600], fontSize: 13)),
                    Text(order['customer_name'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date:', style: TextStyle(color: Colors.blueGrey[600], fontSize: 13)),
                    Text(order['order_date'] != null ? order['order_date'].toString().split(' ')[0] : 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(thickness: 1, color: Colors.grey.shade300),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${order['page_count']}x ${order['service_type']}', style: const TextStyle(fontSize: 14)),
                    Text('₱ ${order['total_price']}', style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('(${order['color_type']} - ${order['document_type']})', style: TextStyle(fontSize: 12, color: Colors.blueGrey[500])),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(thickness: 1, color: Colors.grey.shade300),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL DUE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('₱ ${order['total_price']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[900])),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blueGrey[800],
                      side: BorderSide(color: Colors.blueGrey.shade200),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text('Close Receipt'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Create Order dialog function
  void showCreateOrderDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController docController = TextEditingController();
    TextEditingController pagesController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    
    // Dropdown selections
    String? selectedService;
    String? selectedSize;
    String? selectedColor;
    String orderStatus = 'Pending'; 

    // Show the dialog for creating a new order
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {

            // Function to calculate total price based on selections
            void calculateTotal() {
              double pricePerPage = 0.0;
              int pages = int.tryParse(pagesController.text) ?? 0;
              
              // Pricing logic based on service, size, and color
              if (selectedService == 'Print Text') {
                if (selectedColor == 'Black & White') {
                  if (selectedSize == 'Short') pricePerPage = 2.0;
                  else if (selectedSize == 'Long' || selectedSize == 'A4') pricePerPage = 3.0;
                } else if (selectedColor == 'Colored') {
                  if (selectedSize == 'Short' || selectedSize == 'A4') pricePerPage = 6.0;
                  else if (selectedSize == 'Long') pricePerPage = 7.0;
                }
              } else if (selectedService == 'Print Photo') {
                if (selectedColor == 'Black & White') pricePerPage = 6.0;
                else if (selectedColor == 'Colored') pricePerPage = 10.0;
              } else if (selectedService == 'Xerox') {
                pricePerPage = 2.0; 
              } else if (selectedService == 'Scan') {
                pricePerPage = 5.0; 
              }
              
              // Calculate total price
              double total = pricePerPage * pages;

              // Update the total price field in the dialog
              setStateDialog(() {
                if (total > 0) {
                  priceController.text = total.toStringAsFixed(2);
                } else {
                  priceController.text = '';
                }
              });
            }

            // New Order Form UI
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text('New Print Order', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[900], fontSize: 20)),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Customer Name',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue.shade600)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedService,
                              hint: const Text('Service Type'),
                              decoration: InputDecoration(filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                              items: const [
                                DropdownMenuItem(value: 'Print Text', child: Text('Print Text')),
                                DropdownMenuItem(value: 'Print Photo', child: Text('Print Photo')),
                                DropdownMenuItem(value: 'Xerox', child: Text('Xerox')),
                                DropdownMenuItem(value: 'Scan', child: Text('Scan')),
                              ],
                              onChanged: (newValue) { setStateDialog(() => selectedService = newValue); calculateTotal(); },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: docController,
                              decoration: InputDecoration(labelText: 'Document Type', hintText: 'e.g. Modules', filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedSize,
                              hint: const Text('Paper Size'),
                              decoration: InputDecoration(filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                              items: const [
                                DropdownMenuItem(value: 'Short', child: Text('Short')),
                                DropdownMenuItem(value: 'Long', child: Text('Long')),
                                DropdownMenuItem(value: 'A4', child: Text('A4')),
                              ],
                              onChanged: (newValue) { setStateDialog(() => selectedSize = newValue); calculateTotal(); },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedColor,
                              hint: const Text('Ink Color'),
                              decoration: InputDecoration(filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                              items: const [
                                DropdownMenuItem(value: 'Black & White', child: Text('Black & White')),
                                DropdownMenuItem(value: 'Colored', child: Text('Colored')),
                              ],
                              onChanged: (newValue) { setStateDialog(() => selectedColor = newValue); calculateTotal(); },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: pagesController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) => calculateTotal(), 
                              decoration: InputDecoration(labelText: 'Pages', filled: true, fillColor: const Color(0xFFF8FAFC), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: priceController,
                              readOnly: true, 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[700]),
                              decoration: InputDecoration(
                                labelText: 'Total Price', 
                                filled: true, 
                                fillColor: Colors.blue.withOpacity(0.05), 
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue.shade200)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.blue.shade200))
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: Text('Cancel', style: TextStyle(color: Colors.blueGrey[500], fontWeight: FontWeight.w600)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600], 
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    createOrder(
                      nameController.text, selectedService ?? 'N/A', docController.text,
                      pagesController.text, selectedColor ?? 'N/A', priceController.text,
                      orderStatus
                    );
                  },
                  child: const Text('Create Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          }
        );
      },
    );
  }

  // Main build function for the dashboard
  @override
  Widget build(BuildContext context) {
    int totalOrders = orders.length;
    int pendingCount = orders.where((o) => o['order_status'] == 'Pending').length;
    int printingCount = orders.where((o) => o['order_status'] == 'Printing').length;
    int doneCount = orders.where((o) => o['order_status'] == 'Done').length;

    // Dashboard UI with summary cards, order table, and actions
    return Title(
      title: 'Dashboard | Printing Services',
      color: Colors.blueGrey,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F8),
        appBar: AppBar(
          title: const Text('Printing Services Dashboard', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: -0.5)),
          backgroundColor: Colors.blueGrey[900],
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: ElevatedButton.icon(
                onPressed: showAIInsights,
                icon: const Icon(Icons.auto_awesome, size: 18),
                label: const Text('AI Assistant', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[500],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Logout',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    title: Text('Logout', style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                    content: Text('Are you sure you want to log out?', style: TextStyle(color: Colors.blueGrey[700])),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: Colors.blueGrey[500]))),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[800], elevation: 0),
                        onPressed: () {
                          Navigator.pop(context); 
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                        child: const Text('Logout', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.blue[600]))
            : Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _buildSummaryCard('Total Orders', totalOrders.toString(), Icons.receipt, Colors.blueGrey[700]!),
                        const SizedBox(width: 16),
                        _buildSummaryCard('Pending', pendingCount.toString(), Icons.pending_actions, Colors.orange[700]!),
                        const SizedBox(width: 16),
                        _buildSummaryCard('Printing', printingCount.toString(), Icons.print, Colors.blue[600]!),
                        const SizedBox(width: 16),
                        _buildSummaryCard('Done', doneCount.toString(), Icons.check_circle, Colors.green[600]!),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                    child: DataTable(
                                      headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
                                      dataRowColor: WidgetStateProperty.all(Colors.white),
                                      dividerThickness: 1,
                                      columnSpacing: 40.0,
                                      columns: const [
                                        DataColumn(label: Text('Customer')),
                                        DataColumn(label: Text('Service')),
                                        DataColumn(label: Text('Document')),
                                        DataColumn(label: SizedBox(width: 60, child: Center(child: Text('Pages')))),
                                        DataColumn(label: Text('Total')),
                                        DataColumn(label: SizedBox(width: 105, child: Center(child: Text('Status')))),
                                        DataColumn(label: SizedBox(width: 100, child: Center(child: Text('Actions')))),
                                      ],
                                      rows: orders.map<DataRow>((order) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Text(order['customer_name'].toString(), style: const TextStyle(fontWeight: FontWeight.w500))),
                                            DataCell(Text(order['service_type'] ?? 'N/A')),
                                            DataCell(Text(order['document_type'].toString())),

                                            // Centered Page Count with fixed width to prevent layout shifts 
                                            DataCell(SizedBox(width: 60, child: Center(child: Text(order['page_count'].toString())))),
                                            DataCell(Text('₱ ${order['total_price']}', style: const TextStyle(fontWeight: FontWeight.w600))),
                                          
                                          // Status with colored background and dropdown for updates
                                          DataCell(
                                            SizedBox(
                                              width: 105, 
                                              child: Center(
                                                child: Container(
                                                  height: 32, 
                                                  width: 100, 
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusBgColor(order['order_status'].toString()),
                                                    borderRadius: BorderRadius.circular(16),
                                                    border: Border.all(color: _getStatusTextColor(order['order_status'].toString()).withOpacity(0.3), width: 1),
                                                  ),
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton<String>(
                                                      isExpanded: true, 
                                                      alignment: AlignmentDirectional.center, 
                                                      dropdownColor: Colors.white,
                                                      value: order['order_status'].toString(),
                                                      focusColor: Colors.transparent,
                                                      icon: Icon(Icons.arrow_drop_down, size: 16, color: _getStatusTextColor(order['order_status'].toString())),
                                                      style: TextStyle(
                                                        color: _getStatusTextColor(order['order_status'].toString()),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12 
                                                      ),
                                                      items: <String>['Pending', 'Printing', 'Done'].map<DropdownMenuItem<String>>((String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value, 
                                                          child: Center(child: Text(value, style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.normal)))
                                                        );
                                                      }).toList(),
                                                      onChanged: (String? newValue) {
                                                        if (newValue != null) updateOrderStatus(order, newValue); 
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Actions with icons for receipt and delete, centered and spaced
                                          DataCell(
                                            SizedBox(
                                              width: 100,
                                              child: Center(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min, // Keeps icons tightly centered
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.receipt_long, color: Colors.blue[600]),
                                                      tooltip: 'Digital Receipt',
                                                      onPressed: () => showReceiptDialog(order),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                                                      tooltip: 'Delete Order',
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) => AlertDialog(
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                            title: Text('Delete Order', style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
                                                            content: Text('Are you sure you want to permanently delete this order?', style: TextStyle(color: Colors.blueGrey[700])),
                                                            actions: [
                                                              TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: Colors.blueGrey[500]))),
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600], elevation: 0),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                  deleteOrder(order['order_id'].toString());
                                                                },
                                                                child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          elevation: 2,
          onPressed: showCreateOrderDialog,
          icon: const Icon(Icons.add),
          label: const Text('New Order', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // Helper function to build summary cards for the dashboard
  Widget _buildSummaryCard(String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200)
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.blueGrey[500], fontSize: 13, fontWeight: FontWeight.w600)),
                Text(count, style: TextStyle(color: Colors.blueGrey[900], fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}


// Widget for displaying pie charts of service volume and revenue distribution
class QueuePieChart extends StatelessWidget {
  final List<dynamic> orders;

  // Constructor to initialize the widget with the list of orders
  const QueuePieChart({Key? key, required this.orders}) : super(key: key);

  // Build function to create the UI for the pie charts based on the order data
  @override
  Widget build(BuildContext context) {
    int textCount = orders.where((o) => o['service_type'] == 'Print Text').length;
    int photoCount = orders.where((o) => o['service_type'] == 'Print Photo').length;
    int xeroxCount = orders.where((o) => o['service_type'] == 'Xerox').length;
    int scanCount = orders.where((o) => o['service_type'] == 'Scan').length;

    // Calculate revenue for each service type by summing the total_price of orders for that type
    double textRev = 0, photoRev = 0, xeroxRev = 0, scanRev = 0;
    for(var o in orders) {
      double price = double.tryParse(o['total_price'].toString()) ?? 0;
      if(o['service_type'] == 'Print Text') textRev += price;
      else if(o['service_type'] == 'Print Photo') photoRev += price;
      else if(o['service_type'] == 'Xerox') xeroxRev += price;
      else if(o['service_type'] == 'Scan') scanRev += price;
    }

    // If there are no orders, display a message instead of the charts
    if (orders.isEmpty) {
      return const SizedBox(height: 150, child: Center(child: Text("No data available yet.", style: TextStyle(color: Colors.grey))));
    }

    // Build the UI with two side-by-side pie charts: one for service volume and one for revenue distribution
    return Container(
      height: 250, 
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Service Volume", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
                const SizedBox(height: 10),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2, centerSpaceRadius: 30,
                      sections: [
                        if (textCount > 0) PieChartSectionData(color: Colors.blue[500], value: textCount.toDouble(), title: 'Text\n($textCount)', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        if (photoCount > 0) PieChartSectionData(color: Colors.purple[500], value: photoCount.toDouble(), title: 'Photo\n($photoCount)', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        if (xeroxCount > 0) PieChartSectionData(color: Colors.orange[500], value: xeroxCount.toDouble(), title: 'Xerox\n($xeroxCount)', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        if (scanCount > 0) PieChartSectionData(color: Colors.green[500], value: scanCount.toDouble(), title: 'Scan\n($scanCount)', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Vertical divider between the two charts for better visual separation
          Container(width: 1, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 8)),

          // Second chart for revenue distribution with similar structure to the first chart, but using revenue values instead of counts
          Expanded(
            child: Column(
              children: [
                Text("Revenue (₱)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
                const SizedBox(height: 10),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2, centerSpaceRadius: 30,
                      sections: [
                        if (textRev > 0) PieChartSectionData(color: Colors.blue[400], value: textRev, title: '₱${textRev.toInt()}', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        if (photoRev > 0) PieChartSectionData(color: Colors.purple[400], value: photoRev, title: '₱${photoRev.toInt()}', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        if (xeroxRev > 0) PieChartSectionData(color: Colors.orange[400], value: xeroxRev, title: '₱${xeroxRev.toInt()}', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        if (scanRev > 0) PieChartSectionData(color: Colors.green[400], value: scanRev, title: '₱${scanRev.toInt()}', radius: 55, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}