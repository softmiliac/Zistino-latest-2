# Zistino Project

> Repository: [softmiliac/Zistino-latest-2](https://github.com/softmiliac/Zistino-latest-2)

## Overview

Zistino is a multi-module project for recycling management, customer ordering, and administration, built mainly with Dart (Flutter) and TypeScript. This repository hosts several apps:
- **Customer App** (`zistino-main`): For end-users to manage recycling orders, access location-based services, and interact with recycling machines.
- **Driver App** (`zistino_driver-main`): Flutter application for drivers to manage pickups.
- **Admin/Manager App** (`zistino_manager-master`): For administrators to oversee system operations.
- **Backend/Panel/Web Apps**: Backend APIs, web dashboards, and utilities (some in Node.js, TypeScript, etc.).

## Main Features

- User registration, login, and order management via mobile/web.
- Drivers and Manager interfaces for operations monitoring and fulfillment.
- Data models for secure execution and message passing ([example](https://github.com/softmiliac/Zistino-latest-2/blob/main/zistino_customer_main/zistino-main/lib/src/data/models/sec/send_code_rpm.dart)).
- Modular system, with shared code architecture and independent build/deployment for each app.
- Multi-language/calendar UI support (e.g., Persian calendar pickers).
- Broad use of GetX, Hive, and other modern Flutter libraries.
- Backend API with step-by-step operation flow ([details here](https://github.com/softmiliac/Zistino-latest-2/blob/main/zistino_backend_api/zistino_backend/docs/SIMPLE_EXPLANATION.md)).

## Installation

Each app is a separate Flutter/Node/TS project.
General instructions for Flutter-based submodules (Customer/Driver/Admin):
1. Clone this repository:  
   `git clone https://github.com/softmiliac/Zistino-latest-2`
2. Enter the subdirectory (e.g., `cd zistino_customer_main/zistino-main`)
3. Install dependencies:
   ````
   flutter pub get
   ````
4. To run on web or desktop:
   ````
   flutter run -d chrome
   flutter run -d linux
   ````
   (Requires [Flutter](https://docs.flutter.dev/get-started/install) installed.)

For backend/panel/web-based modules, refer to their individual README.md files.

## Usage

- Launch the app as you would typical Flutter applications ([Example Getting Started](https://github.com/softmiliac/Zistino-latest-2/blob/main/zistino_customer_main/zistino-main/README.md)):
- Backend logic as described in [SIMPLE_EXPLANATION.md](https://github.com/softmiliac/Zistino-latest-2/blob/main/zistino_backend_api/zistino_backend/docs/SIMPLE_EXPLANATION.md) for system flow, error handling, and API behavior.

Example service/component code can be found throughout the repo, e.g. map features, basket/order logic, etc.

## API Reference

- Data model sample: [`SendCodeRPM`](https://github.com/softmiliac/Zistino-latest-2/blob/main/zistino_customer_main/zistino-main/lib/src/data/models/sec/send_code_rpm.dart)
- Frontend app entrypoint: [`main.dart`](https://github.com/softmiliac/Zistino-latest-2/blob/main/zistino_customer_main/zistino-main/lib/main.dart)
- Backend workflow: See [SIMPLE_EXPLANATION.md](https://github.com/softmiliac/Zistino-latest-2/blob/main/zistino_backend_api/zistino_backend/docs/SIMPLE_EXPLANATION.md)

Refer to each submodule's code for additional class/function documentation.

## Contribution Guide

- Fork the repo, work in your branch, and create pull requests for changes.
- See contribution sections in [example package README](https://github.com/softmiliac/Zistino-latest-2/blob/main/zistino_customer_main/zistino-main/edit_packages/flutter_slidable-2.0.0/README.md) for guidelines.
- You can open issues and PRs for bugs, features, or enhancements.

## License

No explicit license file is provided in the root at this time.
Some included packages (e.g., `flutter_slidable`, `persian-datetime-picker`) have their own license terms in the package directories.

## Additional Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Backend module explanation](https://github.com/softmiliac/Zistino-latest-2/blob/main/zistino_backend_api/zistino_backend/docs/SIMPLE_EXPLANATION.md)