# Bhumipun Orders 🌾

**Bhumipun Orders** is a modern, high-performance Flutter application built for agricultural and land record order requests. It guides applicants through an intuitive, validated multi-step workflow with real-time feedback, hierarchical geographic location selection, secure PDF document attachments (with strict size/type checks), offline draft persistence with resume capabilities, and responsive layouts tailored for mobile, tablet, and desktop environments.

---

## 📸 Screenshots

| 1. Contact Details | 2. Order & Geographic Details | 3. Document Verification (PDF) |
|:---:|:---:|:---:|
| ![Step 1 - Contact](screenshots/01_step1_contact_details.png) | ![Step 2 - Order Details](screenshots/02_step2_order_details.png) | ![Step 3 - Documents](screenshots/03_step3_document_uploads.png) |

| 4. Review & Verification | 5. Confirmation & Reference | 6. Adaptive Desktop / Tablet View |
|:---:|:---:|:---:|
| ![Step 4 - Review](screenshots/04_step4_review_and_submit.png) | ![Step 5 - Confirmation](screenshots/05_submission_success.png) | ![Desktop Layout](screenshots/06_responsive_desktop_view.png) |

---

## ✨ Features

### Step 1: Contact Details
- **First Name & Last Name**: Validated for minimum length and alphabetical character constraints.
- **Indian Mobile Number**: Strict validation for 10-digit Indian numbers starting with `6`, `7`, `8`, or `9`, formatted with `+91` indicator.
- **Email Address**: Comprehensive RFC-compliant regex verification.
- **Inline Validation**: Instant visual cues and inline helper messages preventing progression on invalid inputs.

### Step 2: Order Details & Hierarchical Locations
- **Order ID**: Auto-generated tracking identifier with custom editing support.
- **Full Address**: Multi-line address input with length constraints.
- **Hierarchical Location Dropdowns**: Realistic Indian dataset (Gujarat, Maharashtra, Karnataka, Rajasthan, Madhya Pradesh) covering State → District → Taluka → City/Village.
- **Cascade Reset Logic**: Automatically resets child dropdowns whenever a parent jurisdiction changes.
- **PIN Code**: Strict 6-digit Indian postal code validation.
- **Navigation State Preservation**: All selections remain preserved when moving backward or forward across steps.

### Step 3: Mandatory Document Uploads
- **Two PDF Attachments Required**:
  1. **Aadhaar Card** (Government Identity verification)
  2. **Supporting Document** (7/12 land extract, purchase invoice, or land title proof)
- **Format Verification**: Enforces PDF extension (`.pdf`) and MIME type (`application/pdf`).
- **File Size Constraint**: Maximum 2.0 MB per document with exact byte calculation.
- **Actions**: File preview with name, formatted size (`KB`/`MB`), replace file, and delete actions.
- **No Cloud Upload**: All file inspections and validation occur strictly on the client device.

### Save Draft & Offline Resume
- **Local Persistence**: Saves all form fields, dropdown selections, and document metadata to `shared_preferences`.
- **Session Restoration**: Automatically checks and prompts to restore pending drafts when the app relaunches.
- **File Accessibility Verification**: Verifies whether previously selected local files still exist on disk; if deleted or moved, displays a warning asking the user to re-select.
- **Privacy First**: Aadhaar document binary contents are intentionally not serialized into local shared preferences.
- **Clear Draft**: Provides a confirmation modal to clear draft data and start fresh.

### Review, Summary & Mock Submission
- **Live Summary**: Structured review card showing applicant contact information, order details, full geographic breakdown, and document verification tags.
- **Duplicate Submission Guard**: Disables actions and manages loading state during submission.
- **Realistic Local Submission Service**: Simulates realistic local verification with short artificial latency.
- **Unique Reference Generation**: Generates official reference identifiers (e.g. `BHM-20261028-7492`).
- **Success Screen**: Polished receipt screen with one-tap clipboard copy, complete order recap, and option to create another request.

### Responsive & Adaptive Layout
- **Mobile Phones (< 600px)**: Compact single-column stepper with sticky bottom action controls.
- **Tablets (600px - 899px)**: Spaced multi-column forms with responsive width constraints.
- **Desktop / Tablet Landscape (≥ 900px)**: Side-by-side split screen showing active form step on the left and a sticky, real-time updating **Order Summary Panel** on the right.

---

## 🎨 Design Decisions & Color Palette

The visual identity uses a natural, premium earth-tone palette tailored for agriculture and land governance:

| Color | Hex | Usage |
|:---|:---|:---|
| **Forest Green** | `#176B52` | Primary brand color, headers, focus borders, active indicators, and icons |
| **Warm Ivory** | `#F8F6F0` | Scaffold background and surface neutral for reduced eye strain |
| **Terracotta** | `#D9825B` | Accent highlights, secondary buttons, active step badges, and key CTA accents |
| **Charcoal** | `#202925` | Primary typographic color providing high-contrast readability |
| **Error Red** | `#C62828` | Inline form errors, invalid state badges, and warning messages |

---

## 🏛️ Architecture & Folder Structure

The project adopts a clean, feature-driven architecture separating business logic from presentation:

```
lib/
├── app.dart                                # MaterialApp, theme, and BlocProvider setup
├── main.dart                               # App entry point with repository injection
├── core/
│   ├── constants/
│   │   ├── app_colors.dart                 # Brand palette definitions
│   │   ├── app_strings.dart                # User-facing copy and error messages
│   │   └── app_theme.dart                  # Material 3 light theme configuration
│   └── utils/
│       ├── formatters.dart                 # Byte sizes, phone numbers, and dates
│       └── validators.dart                 # Email, mobile, PIN, and PDF validators
└── features/
    └── order/
        ├── bloc/
        │   ├── order_bloc.dart             # State management for steps, drafts, submit
        │   ├── order_event.dart            # User actions and form input events
        │   └── order_state.dart            # Immutable UI state models
        ├── data/
        │   ├── locations_data.dart         # Hierarchical Indian locations dataset
        │   ├── models/
        │   │   ├── document_file_model.dart# Document metadata model
        │   │   └── order_request_model.dart# Order form entity with step validation
        │   └── repositories/
        │       ├── draft_repository.dart   # SharedPreferences persistence & file check
        │       └── submission_repository.dart# Local mock submission engine
        └── presentation/
            ├── screens/
            │   ├── order_form_screen.dart  # Responsive multi-step screen
            │   └── submission_success_screen.dart # Confirmation receipt screen
            └── widgets/
                ├── contact_details_step.dart
                ├── custom_dropdown.dart
                ├── custom_text_field.dart
                ├── document_upload_card.dart
                ├── document_uploads_step.dart
                ├── order_details_step.dart
                ├── order_summary_card.dart
                ├── review_and_submit_step.dart
                └── step_header.dart
```

---

## 🚀 Setup & Execution Guide

### Prerequisites
- Flutter SDK `^3.47.0` (Dart `^3.13.0`)
- Android SDK 34+ / JDK 17+

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Format Code
```bash
dart format .
```

### 3. Run Static Code Analysis
```bash
flutter analyze
```

### 4. Run Automated Test Suite
```bash
flutter test
```

### 5. Run the Application
```bash
# Run on connected Android device or emulator
flutter run

# Or run on Windows desktop
flutter run -d windows

# Or run on Chrome
flutter run -d chrome
```

---

## 📦 Android APK Release Build

To build the optimized production release APK:

```bash
flutter build apk --release
```

The compiled release APK is located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧪 Testing Coverage

The project includes unit and widget tests covering:
- **Validators Unit Tests**: Required fields, name regex, Indian mobile regex, PIN code validation, PDF format and 2 MB boundary checks.
- **Locations Data Tests**: Hierarchical district, taluka, and village lookup logic.
- **OrderBloc Unit Tests**: State transitions, cascade dropdown resets, navigation guardrails, document additions/deletions, draft save/restore, and duplicate submission prevention.
- **Widget Tests**: Rendering of all 4 steps, real-time input validation, navigation triggers, draft saving notifications, and success screen confirmation.

To run tests with full logs:
```bash
flutter test --reporter expanded
```

---

## ⚠️ Known Limitations
- **Local Demonstration Mode**: Submissions are verified and processed entirely on the local device without network upload.
- **File System Persistence**: If the device's temporary cache is flushed by the OS or files are moved, the draft repository detects this and requests the applicant to re-select the file.
