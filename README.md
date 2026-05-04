# Printing Services Dashboard

## Project Overview
This project is a localized, full-stack management dashboard designed for a home-based document and printing service. It allows the users to track customer requests, update printing statuses, and manage payment statuses in real-time. 

### Core Feature: AI Assistant Integration
The defining "Emerging Tech" feature of this system is the integration of the **Google Gemini AI API**. Users can input complex, messy customer requests, and the AI will automatically parse the text, calculate the total price based on a hidden pricing matrix, and format it into clean JSON data to be pushed to the database.

## Tech Stack
*   **Frontend:** Flutter (Dart) - Cross-platform UI dashboard
*   **Backend:** PHP - RESTful API endpoints handling data logic
*   **Database:** MySQL (via XAMPP) - Relational data storage
*   **AI Integration:** Google Gemini API (via HTTP requests)

## Setup Instructions
To run this project locally, please follow these steps:

**1. Database Setup**
*   Turn on Apache and MySQL in your XAMPP Control Panel.
*   Open `localhost/phpmyadmin` in your browser.
*   Create a new database named `printing_db`.
*   Import the provided `printing_db.sql` file into this new database.

**2. Backend (API) Setup**
*   Copy the `printing_api` folder from this repository.
*   Paste it into your XAMPP `htdocs` directory (usually `C:\xampp\htdocs\printing-services-final/printing_api`).

**3. Frontend (Flutter) Setup**
*   Open the `printing_manager` folder in VS Code.
*   Run `flutter pub get` to install necessary dependencies (like `http`).
*   Run the app using `flutter run`.
