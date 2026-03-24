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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text('Admin Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) => login(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: login,
                  child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
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
    TextEditingController serviceController = TextEditingController();
    TextEditingController docController = TextEditingController();
    TextEditingController pagesController = TextEditingController();
    TextEditingController colorController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    String orderStatus = 'Pending';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Create New Order', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),

              // Print Type
              DropdownButtonFormField<String>(
                value: serviceController.text.isEmpty ? null : serviceController.text,
                hint: const Text('Select print type...'),
                decoration: InputDecoration(
                  labelText: 'Print Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: const [
                  DropdownMenuItem(value: 'Print', child: Text('Print')),
                  DropdownMenuItem(value: 'Xerox', child: Text('Xerox')),
                  DropdownMenuItem(value: 'Scan', child: Text('Scan')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    serviceController.text = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextField(
                controller: docController,
                decoration: InputDecoration(
                  labelText: 'Document Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pagesController,
                decoration: InputDecoration(
                  labelText: 'Page Count',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),

              // Dropdown for Color Type
              DropdownButtonFormField<String>(
                value: colorController.text.isEmpty ? null : colorController.text,
                hint: const Text('Select color type...'),
                decoration: InputDecoration(
               labelText: 'Color Type',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: const [
                DropdownMenuItem(value: 'Black & White', child: Text('Black & White')),
                DropdownMenuItem(value: 'Colored', child: Text('Colored')),
              ],
                onChanged: (String? newValue) {
                  setState(() {
                    colorController.text = newValue!;
                  });
                },
              ),  
              const SizedBox(height: 16),

              // Price input
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Total Price (₱)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[800],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
            onPressed: () {
              Navigator.pop(context);
              createOrder(
                nameController.text,
                serviceController.text,
                docController.text,
                pagesController.text,
                colorController.text,
                priceController.text,
                orderStatus,
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
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
              // Sends back to the Login Screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
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