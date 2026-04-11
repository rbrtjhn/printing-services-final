import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        primarySwatch: Colors.indigo,
      ),
      home: const LoginScreen(),
    );
  }
}

// LoginScreen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    try {
      // Sending the username and password to PHP API
      final response = await http.post(
        Uri.parse('http://localhost/printing-services-final/printing_api/login.php'),
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // If PHP says success is true, it directs to the dashboard
        if (data['success'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          // If PHP says false, it will show the error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Database connection error! Is XAMPP running?')),
      );
    }
  }

  bool _isObscure = true;

  // Login UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(32),
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.cyan, Colors.pinkAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Icon(Icons.print_outlined, size: 70, color: Colors.white),
                ),
              const SizedBox(height: 16),
              Text(
                'Printing Services Login',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
              const SizedBox(height: 32),

              // Username Field
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.cyan)),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: passwordController,
                obscureText: _isObscure,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) => login(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.cyan)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Login Button
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Colors.cyan, Colors.pinkAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [BoxShadow(color: Colors.pinkAccent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Login', style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Dashboard Screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  // API Functions
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

  // The HTTP POST Function
  Future<void> createOrder(
    String customerName,
    String serviceType,
    String documentType,
    String pageCount,
    String colorType,
    String totalPrice,
    String orderStatus,
  ) async {
  

    var url = Uri.parse('http://localhost/printing-services-final/printing_api/add_order.php'); 

    try {
      var response = await http.post(
        url,
        body: {
          "customer_name": customerName,
          "service_type": serviceType,
          "document_type": documentType,
          "page_count": pageCount,
          "color_type": colorType,
          "total_price": totalPrice,
          "order_status": orderStatus,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order Successfully Added!', style: TextStyle(color: Colors.white)),
            duration: Duration(seconds: 2),
          ),
        );

      // Refresh the table instantly
      fetchOrders();
    } else {
        print("Error: ${response.statusCode}");
    }
  } catch (e) {
      print("Failed to connect to server: $e");
    }
  }

  Future<void> updateOrderStatus(String id, String status) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/printing-services-final/printing_api/update_status.php'),
        body: {'order_id': id, 'order_status': status},
      );
      if (response.statusCode == 200) {
        fetchOrders();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status updated!')));
      }
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/printing-services-final/printing_api/delete_order.php'),
        body: {'order_id': id},
      );
      if (response.statusCode == 200) {
        fetchOrders();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order deleted!')));
      }
    } catch (e) {
      print("Error deleting order: $e");
    }
  }


// UI Dialog
  void showCreateOrderDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController docController = TextEditingController();
    TextEditingController pagesController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    
    // Variables to hold the dropdown states
    String? selectedService;
    String? selectedSize;
    String? selectedColor;
    String orderStatus = 'Pending';

    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder allows the dialog to rebuild live as we type!
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            
            // THE BRAIN: Automatic Pricing Logic
            void calculateTotal() {
              double pricePerPage = 0.0;
              int pages = int.tryParse(pagesController.text) ?? 0;

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
                pricePerPage = 2.0; // Flat rate
              } else if (selectedService == 'Scan') {
                pricePerPage = 5.0; // Flat rate
              }

              // Apply the math
              double total = pricePerPage * pages;
              
              setStateDialog(() {
                if (total > 0) {
                  priceController.text = total.toStringAsFixed(2);
                } else {
                  priceController.text = '';
                }
              });
            }

            return AlertDialog(
              backgroundColor: Colors.grey[50],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Create New Order', 
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Customer Name
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Customer Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.cyan, width: 2)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Print Type & Document Type Row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedService,
                            hint: const Text('Print Type...'),
                            decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                            items: const [
                              DropdownMenuItem(value: 'Print Text', child: Text('Print Text')),
                              DropdownMenuItem(value: 'Print Photo', child: Text('Print Photo')),
                              DropdownMenuItem(value: 'Xerox', child: Text('Xerox')),
                              DropdownMenuItem(value: 'Scan', child: Text('Scan')),
                            ],
                            onChanged: (newValue) {
                              setStateDialog(() => selectedService = newValue);
                              calculateTotal(); // Trigger calculation
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: docController,
                            decoration: InputDecoration(labelText: 'Document Type', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Paper Size & Color Type Row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedSize,
                            hint: const Text('Paper Size...'),
                            decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                            items: const [
                              DropdownMenuItem(value: 'Short', child: Text('Short')),
                              DropdownMenuItem(value: 'Long', child: Text('Long')),
                              DropdownMenuItem(value: 'A4', child: Text('A4')),
                            ],
                            onChanged: (newValue) {
                              setStateDialog(() => selectedSize = newValue);
                              calculateTotal(); // Trigger calculation
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedColor,
                            hint: const Text('Color Type...'),
                            decoration: InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                            items: const [
                              DropdownMenuItem(value: 'Black & White', child: Text('Black & White')),
                              DropdownMenuItem(value: 'Colored', child: Text('Colored')),
                            ],
                            onChanged: (newValue) {
                              setStateDialog(() => selectedColor = newValue);
                              calculateTotal(); // Trigger calculation
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Page Count & Total Price Row
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: pagesController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) => calculateTotal(), // Calculates EVERY time you type a number!
                            decoration: InputDecoration(labelText: 'Pages', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: priceController,
                            readOnly: true, // Stops you from manually changing the math
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo),
                            decoration: InputDecoration(
                              labelText: 'Total Price (₱)', 
                              filled: true, 
                              fillColor: Colors.indigo[50], 
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: Text('Cancel', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold)),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(colors: [Colors.cyan, Colors.pinkAccent]),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    onPressed: () {
                      Navigator.pop(context);
                      // Send the selected values back to the PHP database
                      createOrder(
                        nameController.text,
                        selectedService ?? 'N/A',
                        docController.text,
                        pagesController.text,
                        selectedColor ?? 'N/A',
                        priceController.text,
                        orderStatus,
                      );
                    },
                    child: const Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text('Cancel', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => const LoginScreen()), 
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Main Dashboard UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Printing Services Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              _showLogoutDialog();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        // LayoutBuilder helps the DataTable stretch properly without crashing
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(Colors.indigo[50]),
                                    columnSpacing: 40.0,
                                    columns: const [
                                      DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Print Type', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Document', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Pages', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Color', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                                    ],
                                    rows: orders.map<DataRow>((order) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(order['customer_name'].toString())),
                                          DataCell(Text(order['service_type'] ?? 'N/A')),
                                          DataCell(Text(order['document_type'].toString())),
                                          DataCell(Text(order['page_count'].toString())),
                                          DataCell(Text(order['color_type'].toString())),
                                          // Peso sign
                                          DataCell(Text('₱ ${order['total_price']}')),
                                          DataCell(
                                            DropdownButton<String>(
                                              value: order['order_status'].toString(),
                                              focusColor: Colors.transparent,
                                              underline: const SizedBox(),
                                              items: <String>['Pending', 'Printing', 'Done']
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                if (newValue != null) {
                                                  updateOrderStatus(order['order_id'].toString(), newValue);
                                                }
                                              },
                                            ),
                                          ),
                                          DataCell(
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text('Delete Order'),
                                                    content: const Text('Are you sure you want to delete this order?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child: const Text('Cancel'),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
        onPressed: showCreateOrderDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}