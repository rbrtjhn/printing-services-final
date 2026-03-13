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
      home: const DashboardScreen(),
    );
  }
}

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

  // --- API FUNCTIONS ---
  Future<void> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/printing_api/get_orders.php'));
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

  Future<void> createOrder(String name, String docType, String pages, String color, String price, String status) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/printing_api/add_order.php'),
        body: {
          'customer_name': name,
          'document_type': docType,
          'page_count': pages,
          'color_type': color,
          'total_price': price,
          'order_status': status,
        },
      );
      if (response.statusCode == 200) {
        fetchOrders();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order created successfully!')));
      }
    } catch (e) {
      print("Error creating order: $e");
    }
  }

  Future<void> updateOrderStatus(String id, String status) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/printing_api/update_status.php'),
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
        Uri.parse('http://localhost/printing_api/delete_order.php'),
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

  // --- UI DIALOG ---
  void showCreateOrderDialog() {
    TextEditingController nameController = TextEditingController();
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
              TextField(
                controller: colorController,
                decoration: InputDecoration(
                  labelText: 'Color Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Total Price (₱)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: orderStatus,
                decoration: InputDecoration(
                  labelText: 'Order Status',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: const [
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'Printing', child: Text('Printing')),
                  DropdownMenuItem(value: 'Done', child: Text('Done')),
                ],
                onChanged: (val) {
                  if (val != null) orderStatus = val;
                },
              ),
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

  // --- MAIN UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          '🖨️ Printing Services Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo[800],
        elevation: 0,
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
                        // LayoutBuilder helps the DataTable stretch properly without crashing!
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
                                    columns: const [
                                      DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Document', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Pages', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                                    ],
                                    rows: orders.map<DataRow>((order) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(order['customer_name'].toString())),
                                          DataCell(Text(order['document_type'].toString())),
                                          DataCell(Text(order['page_count'].toString())),
                                          // Here is your official Peso sign!
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
        onPressed: showCreateOrderDialog,
        icon: const Icon(Icons.add),
        label: const Text("New Order", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}