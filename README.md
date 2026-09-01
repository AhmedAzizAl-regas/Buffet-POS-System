# Buffet POS System 🍔🧾

A robust, enterprise-grade Point of Sale (POS) & Restaurant Management solution engineered for buffet-style restaurants and cafeterias. Built with **Flutter**, this system prioritizes offline-first reliability, supplier ledger management, multi-currency support, dark/light aesthetics, and Clean Architecture.

## 📸 Screenshots

Below is a polished gallery showcasing the app UI (click any image to open in a new tab):


<div align="center">
   <table>
      <tr>
         <td style="padding:6px"><a href="https://postimg.cc/PLYJZTy6" target="_blank"><img src="https://i.postimg.cc/cJ5npJnN/photo-5812114268424442318-y-(1).jpg" alt="Screenshot 1" width="420" style="border-radius:6px; box-shadow:0 6px 18px rgba(0,0,0,0.12);" /></a></td>
         <td style="padding:6px"><a href="https://postimg.cc/Tyg1mf0s" target="_blank"><img src="https://i.postimg.cc/s20hk2h3/photo-5816814337035800628-y.jpg" alt="Screenshot 2" width="420" style="border-radius:6px; box-shadow:0 6px 18px rgba(0,0,0,0.12);" /></a></td>
         <td style="padding:6px"><a href="https://postimg.cc/vxBGPsrv" target="_blank"><img src="https://i.postimg.cc/Kj748c4C/photo-5816814337035800631-y.jpg" alt="Screenshot 5" width="420" style="border-radius:6px; box-shadow:0 6px 18px rgba(0,0,0,0.12);" /></a></td>
      </tr>
      <tr>
         <td style="padding:6px"><a href="https://postimg.cc/2qhyvrGX" target="_blank"><img src="https://i.postimg.cc/vmSVJmVM/photo-5816814337035800629-y.jpg" alt="Screenshot 3" width="420" style="border-radius:6px; box-shadow:0 6px 18px rgba(0,0,0,0.12);" /></a></td>
         <td style="padding:6px"><a href="https://postimg.cc/06DjmPn3" target="_blank"><img src="https://i.postimg.cc/g0BZC0ZY/photo-5816814337035800630-y.jpg" alt="Screenshot 4" width="420" style="border-radius:6px; box-shadow:0 6px 18px rgba(0,0,0,0.12);" /></a></td>
         <td style="padding:6px"><a href="https://postimg.cc/q6RpmTsL" target="_blank"><img src="https://i.postimg.cc/XqKXYNXT/photo-5816814337035800632-y.jpg" alt="Screenshot 6" width="420" style="border-radius:6px; box-shadow:0 6px 18px rgba(0,0,0,0.12);" /></a></td>
      </tr>
   </table>
</div>

_Gallery: 3 columns × 2 rows — images are clickable to view full size. Images use clearer direct thumbnails._

---

## 🏗 Architecture & Design

This project strictly adheres to **Clean Architecture** principles:

- **Domain Layer:** Core business logic, Entities (`ProductEntity`, `AddEntity`, `SupplierEntity`, `SupplierTransactionEntity`), and Repository abstractions.
- **Data Layer:** SQLite/Floor implementations, database services, and data mappers.
- **Presentation Layer:** Reactive state management via **Riverpod**, responsive UI, and full dark/light theme support.

---

## 🚀 Key Features

### 🏢 Supplier Accounts & Ledger System (الموردين والحسابات)
- **Supplier Directory:** Complete supplier profiles with phone numbers, emails, addresses, and balance tracking.
- **Ledger Transactions (القيود اليومية):** Automated tracking of credit transactions (دائن / مشتريات بالآجل) and debit payments (مدين / سداد نقدي).
- **Daily Accounts Dashboard:** Real-time metrics for daily sales, credit purchases, supplier repayments, and net profit.

### 🛒 Cash & Credit Purchase Management (الشراء نقداً وآجلاً والكميات)
- **Flexible Purchase Toggles:** Options for "لا يوجد شراء نقداً" (No Cash Purchase) and "لا يوجد شراء أجلاً" (No Credit Purchase) with input locking.
- **Stock Allocation & Validation:** Strict quantity checks ensuring cash + credit quantities match total available stock without over-allocation errors.
- **3 Quantity Calculation Priority Modes:**
  1. *Credit First, then Cash (حساب كمية الأجل أولاً ثم النقد)*.
  2. *Cash First, then Credit (حساب كمية النقد أولاً ثم الأجل)*.
  3. *Automatic / Manual (تلقائياً / يدوي)*.

### 🔤 Multi-Currency & Symbol System (إدارة العملات العربية والإنجليزية)
- **Dual-Language Symbols:** Dynamic currency configuration storing both Arabic symbols (e.g. `ر.س`, `ريال`, `$`, `ج.م`) and English codes/symbols (e.g. `SAR`, `YR`, `$`, `EGP`).
- **Interactive Currency Management:** Sheet for adding new custom currencies or editing existing currencies in real-time.

### 📄 Corporate PDF Reports & Invoices (طباعة الفواتير والتقارير PDF)
- **Order Receipts & Invoices:** PDF generation for customer receipts with itemized add-ons and tax breakdown.
- **Sales History Report:** Comprehensive PDF reports for historical sales analytics.
- **Daily Accounts & Ledger Report:** Complete daily financial ledger PDF reports for supplier transactions with RTL parenthesis formatting and language-aware currency badges.

### 🌙 Modern UI & Dark Mode (الوضع الداكن والفاتح)
- Dynamic theme switching (Light / Dark) across all screens, dialogs, and bottom sheets.
- Responsive layout supporting Arabic (RTL) and English (LTR).

---

## 🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev) (v3.0.0+)
- **State Management:** [Riverpod](https://riverpod.dev)
- **Database:** [SQLite / sqflite](https://pub.dev/packages/sqflite)
- **PDF & Printing:** [pdf](https://pub.dev/packages/pdf) & [printing](https://pub.dev/packages/printing)
- **Localization:** Flutter `AppLocalizations` (Arabic & English)

---

## 📂 Project Structure

```text
lib/
├── core/                 # Constants, themes, providers, and PDF printing helpers
│   ├── database/         # SQLite DatabaseService
│   ├── providers/        # Config and common Riverpod providers
│   └── utils/            # ArabicPdfHelper, PrintHelper, Toaster, FormatExtensions
├── features/             # Clean Architecture feature modules
│   ├── auth/             # Authentication & User Management
│   ├── catalog/          # Products, Addons, Categories & Cash/Credit Form Logic
│   ├── pos/              # Point of Sale, Cart, & Order Placement
│   ├── orders/           # Order History & Invoice Viewing
│   ├── suppliers/        # Supplier Directory, Ledger & Daily Accounts
│   └── settings/         # App Settings, Currency Management, & Data Backup/Restore
└── l10n/                 # ARB localization files (intl_ar.arb, intl_en.arb)
```

---

## ⚙️ Installation & Setup

1. **Clone & Fetch Dependencies:**
   ```bash
   git clone https://github.com/username/buffet_app.git
   flutter pub get
   ```

2. **Run Development Build:**
   ```bash
   flutter run
   ```

3. **Build Production APK:**
   ```bash
   flutter build apk --release --split-per-abi
   ```

---

## 📜 License & Author

- **Author:** Ahmed Aziz
- **License:** Licensed under the **MIT License**.
