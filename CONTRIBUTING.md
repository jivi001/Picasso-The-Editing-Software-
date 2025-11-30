# Contributing to Picasoo

## Code Style

### C++
*   Standard: C++20
*   Style: Google C++ Style Guide
*   Indentation: 4 spaces

### Dart / Flutter
*   Style: Effective Dart
*   Line length: 120 characters

## Workflow

1.  Create a feature branch (`feature/my-new-feature`).
2.  Commit your changes.
3.  Push to the branch.
4.  Create a Pull Request.

## IPC Protocol

Communication between Flutter and C++ uses JSON over Named Pipes.
*   **Request**: `{ "id": "uuid", "method": "MethodName", "params": { ... } }`
*   **Response**: `{ "id": "uuid", "result": { ... }, "error": null }`
