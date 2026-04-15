**Printing Services Management System**


**Overview**
The Printing Services Management System is a full-stack, cross-platform application designed to automate pricing, track customer orders, and manage digital receipts for a local printing business. Built with a Flutter frontend and a PHP/MySQL backend, the system streamlines the transition from physical order slips to a fully digital dashboard.


**Core Features (Deliverable 2 Updates)**
**Automated Dynamic Pricing**: Calculates exact totals based on document type, color, paper size, and page count in real-time.
**Digital Receipt Generator**: Instantly renders a professional, screenshot-ready digital receipt for corporate clients and record-keeping.
**Automated SMS Notification Logic**: Backend architecture designed to trigger conditional SMS alerts when an order status is updated to "Done," ensuring clients are notified for pickup and payment.
**Full CRUD Operations**: Seamlessly Create, Read, Update, and Delete customer orders through a connected XAMPP local server.


**Technology Stack**
Frontend: Flutter (Dart)
Backend: PHP (REST API)
Database: MySQL (phpMyAdmin)
Server: XAMPP (Localhost)


**Setup & Installation Instructions**
To run this project locally for grading or testing, follow these exact steps:

1. **Database Setup**:
- Launch XAMPP and start the Apache and MySQL modules.
- Open your browser and go to http://localhost/phpmyadmin.
- Create a new database named printing_db.
- Import the provided printing_db.sql file (or manually create the tbl_orders and users tables).

2. **Backend API Setup**:
- Place the printing-services-final folder (containing the PHP scripts) into your XAMPP htdocs directory (C:\xampp\htdocs\).

3. **Flutter App Setup**:
- Open the Flutter project folder in Visual Studio Code or Android Studio.
- Run flutter pub get in the terminal to install any required dependencies (like the http package).
- Ensure your emulator is running or your physical device is connected.
- Note: If running on a physical Android device, ensure the API URLs in main.dart point to your computer's local IPv4 address instead of localhost.
- Press F5 or run flutter run to launch the application.
