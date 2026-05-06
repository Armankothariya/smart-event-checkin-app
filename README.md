#  Smart Event Check-in & Crowd Management App

##  Author

**Kothariya Mohamad Arman**

---

##  Overview

This project is a Flutter-based mobile application designed to simplify event management by enabling fast and efficient participant check-ins. It reduces manual effort, prevents duplicate entries, and provides real-time crowd monitoring.

---

##  Features

* QR code and manual check-in
* Duplicate entry prevention
* Real-time attendance tracking
* Crowd capacity monitoring: Safe, Moderate, or Full
* Offline support using local storage
* Automatic data sync when online
* Participant search and check-in logs

---

##  Tech Stack

* **Flutter** – UI development
* **Dart** – Application logic
* **Hive** – Offline storage
* **Riverpod / Provider** – State management
* **QR Scanner Plugin** – QR code scanning

---

##  Screens

1. Event Setup Screen
2. Check-in Screen (QR + Manual Entry)
3. Dashboard Screen (Live Attendance Overview)
4. Logs and Search Screen

---

##  How to Run

```bash
flutter pub get
flutter run
```

---



##  Brief Explanation of Features Implemented

The app includes QR code and manual check-in options to make participant entry fast and flexible. It prevents duplicate entries by checking whether a participant has already been marked as present. Real-time attendance tracking helps organizers monitor the number of checked-in participants during the event.

The crowd capacity monitoring feature shows the current crowd status as Safe, Moderate, or Full based on the event capacity. Offline support using Hive allows the app to store check-in data locally when there is no internet connection. Once the device is online again, automatic sync can update the stored data.

The search and logs feature helps organizers quickly find participant records and review check-in history.

---

##  Future Scope

* Add cloud-based admin panel for managing multiple events
* Implement role-based access (organizers, volunteers, admins)
* Add advanced analytics and attendance reports
* Send SMS or email confirmation after check-in
* Improve QR code security with encrypted IDs
* Export attendance data as CSV or PDF
* Add live notifications for crowd capacity alerts
* Support multi-device synchronization

---

##  Conclusion

The Smart Event Check-in & Crowd Management App provides an efficient and reliable way to manage participant entry at events. By combining QR scanning, manual check-in, duplicate prevention, offline storage, and real-time crowd monitoring, the app reduces manual work and improves event flow.

This project helps organizers manage attendance more accurately, avoid overcrowding, and ensure a smoother check-in experience for participants.

---




```

