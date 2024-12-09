
#  Driver Rating App

**Driver Rating App	**is a Flutter-based mobile application designed for posting, reviewing, and commenting,The app integrates Firebase for seamless authentication, data storage, and real-time updates.

---


## 🛠️ Tech Stack
- 🐦 **Flutter**: Version 3.24.3
- 🎯 **Dart**: Version 3.5.3


---

## 📁 Folder Structure

The project is organized into the following folder structure for better modularity and maintainability:

lib/
├── 🧩 core/                   # Core functionality and utilities
│   ├── authentication.dart    
│   ├── database.dart         
├── 📦 Model/                  # Data models representing application objects
│   ├── comment_model.dart     
│   ├── post_model.dart        
│   ├── userModel.dart       
├── 📱 Screens/                # App screens and UI components
│   ├── AuthScreens/           # Authentication-related screens
│   │   ├── forgot_screen.dartn
│   │   ├── signin.dart        
│   │   ├── signup.dart       
│   ├── commenting_screen.dart # Screen for commenting
│   ├── home.dart              
│   ├── info_add.dart          
├── 🛠️ widgets/                # Reusable UI components
│   ├── loginfield.dart        
│   ├── passwordField.dart    
│   ├── textfield.dart         
├── 🚀 main.dart               
├── 📄 pubspec.yaml


--- 
## 🚀 Getting Started

Follow these instructions to set up and run the app locally.

### ✅ Prerequisites

Ensure the following tools are installed on your system: - **Flutter SDK**: Install the latest version from the [Flutter website](https://flutter.dev/docs/get-started/install). - **Git**: Install Git for version control. - **Code Editor**: Use an editor like **VS Code** or **Android Studio** for development.

### 🛠️ Installation Steps
1. **Clone the repository**: ```bash git clone https://github.com/usrname/driver-rating.git

2. **Install dependencies**
   Run the following command to fetch and install required packages:
```bash
flutter pub get
```
3. **Run the app**
``` bash
flutter run
```
