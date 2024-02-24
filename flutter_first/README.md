# flutter_first ReadMe

flutter_first is a versatile project designed for legal aid purposes, this project comprises of the frontend interface for our submission to the google Solutions challenge 2024. This comprehensive guide will provide you with everything you need to know to get started with the project, from installation instructions to a detailed description of its features.

## Table of Contents

- [Features](#features)

- [Installation](#installation)

- [Usage](#usage)

- [Contributing](#contributing)

  

## Features 
- File System: The app has a file system implemented inside it, with subfolders and files subsequently
  
- Html Render: our app also supports rendering code that comes from api calls in the form of a string with html code and convert it into flutter widgets. This has been achieved with the help of the package <a href="https://pub.dev/packages/flutter_widget_from_html"> flutter_widget_from_html </a>. This package provides support for a wide variety of tags and also image file support
  
- File picking: We are picking files from external storage and putting them inside of the file system we have built inside the app. We have used various packages for it like <a href="https://pub.dev/packages/permission_handler"> permission_handler </a> and <a href="https://pub.dev/packages/file_picker"> file_picker </a>. Handling storage permissions for an app has been changed since android 13, so the developer should be aware of the platform that they are working for when handling permissions. <i>Multiplatform support is possible by adding conditional statements according to the sdk versions</i>

## Installation
- Make sure you have an environment where you can run flutter projects
- Clone the repository using git clone
- Change the working directory to the the flutter project named flutter_first
  <br>if you are working with android studio, then open the project named flutter_first and you can now work with the flutter end of the project. Any other IDEs could be worked with in the exact same way

- open the terminal and run the command
  ```sh
  flutter pub get 
  ```
  this command resolves all the dependencies needed for the project, the version numbers and names of these dependencies are mentioned in the file pubspec.yaml under the dependencies section

- After this, the project should be ready to run, execute this command on the terminal
  ```sh
  flutter run
  ```
  This process can take a little bit of time, android studio offers both digital emulators and running with cables by usb debugging on a real device. Android studio also has a feature known as hot reload which can reduce this time by a huge amount for testing purposes. Search more about <a href="https://docs.flutter.dev/tools/hot-reload">hot reload</a> in the documentation.

## Usage

- The app opens up on the signup/login page, which requires a phone number which takes you to the otp page for the verification of the phone number.
  <br> <i>For testing purposes, you might wanna redirect the routes in a way which skips the otp page entirely as it can be a tedious task to do repeatedly</i>

- Then we arrive at the dashboard page of the app after a successful otp verification. Now we have multiple use cases, the main three functionalities of the app can be seen now, precedent searching, law searching, and legal file management

## Contributing

We welcome contributions to flutter_first. If you would like to contribute to the development or report issues, please follow these guidelines:

1. Fork the repository.

2. Create a new branch for your feature or bug fix.

3. Make your changes and commit them with descriptive messages.

4. Push your changes to your fork.

5. Submit a pull request to the main repository.


