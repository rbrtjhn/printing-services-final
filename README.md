# Printing Services Management System

This is the system I built for my IT309 project. Since I actually handle printing for my family, relatives, and neighbors at home, I wanted to build something practical that replaces my messy manual notes app and calculator. 

It's a Flutter app connected to a local PHP/MySQL backend that tracks orders, computes prices automatically, and manages receipts.

### What's Inside (Deliverable 2 Updates)
* **Auto-Calculator:** No more guessing prices. You just input the pages, paper size, and whether it's colored or black-and-white, and it computes the exact total instantly.
* **Digital Receipts:** Instead of buying a physical thermal printer, the app generates a clean, POS-style receipt on the screen. I can just screenshot it and send it to the customer via Messenger.
* **Automated SMS Logic:** The backend is wired up to trigger an SMS workflow the moment an order status is changed to "Done" in the dashboard. This reminds people to pick up their prints and pay their balances.
* **Order Management:** Full create, read, update, and delete capabilities directly tied to the local database.

### Built With
* **Frontend:** Flutter (Dart)
* **Backend:** PHP
* **Database:** MySQL
* **Local Server:** XAMPP

---

### How to run this on your machine
If you need to test this project, here is how to get it running locally:

**1. Set up the Database**
* Open XAMPP and start Apache and MySQL.
* Open your browser, go to `http://localhost/phpmyadmin`, and create a database called `printing_db`.
* Import the `printing_db.sql` file included in this repository.

**2. Connect the Backend**
* Grab the `printing-services-final` folder (which has all the PHP files) and paste it into your XAMPP `htdocs` folder (usually `C:\xampp\htdocs\`).

**3. Run the Flutter App**
* Open the Flutter project folder in VS Code or Android Studio.
* Run `flutter pub get` in the terminal just to make sure the HTTP packages are installed.
* **Important Note:** If you are testing this on a physical Android phone instead of an emulator, you need to open `main.dart` and change `localhost` in the API links to your computer's actual IPv4 Wi-Fi address. Otherwise, the phone won't be able to talk to XAMPP.
* Hit Run (F5) and try adding an order!
