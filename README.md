# Adhyayan

Adhyayan is a comprehensive course-selling and streaming platform built with Flutter, Node.js, Express, and MongoDB. It offers a range of features including course management, video streaming, user authentication, and more.

## Features

- **User Authentication**: Sign up, log in, and password recovery.
- **Course Management**: Upload courses, manage lessons, and save or enroll in courses.
- **Profile Management**: View and edit user profiles.
- **Navigation**: Intuitive navigation bar to access different sections of the app.

## Screenshots

### Signup and Login
| Signup Page | Login Page |
|-------------|------------|
| ![Signup](https://github.com/user-attachments/assets/ea2498ae-faf8-446b-9e60-e9867a57ec24) | ![Login](https://github.com/user-attachments/assets/f283b290-fcba-40e6-a34e-deb6c3be0992) |

### Home and Navigation
| Home Page | Navigation Bar |
|-----------|----------------|
| ![Home](https://github.com/user-attachments/assets/7235495d-1412-4966-bc61-3e516e0c9e0c) | ![NavBar](https://github.com/user-attachments/assets/febb0c3e-954b-4fe6-897c-4445982446e9) |

### Course Management
| Saved Courses | Enrolled Courses | Upload Course Page |
|---------------|-------------------|--------------------|
| ![Saved Courses](https://github.com/user-attachments/assets/1ce3aee5-a6d1-4e23-8372-60814eb1b8da) | ![Enrolled Courses](https://github.com/user-attachments/assets/81dbf6c2-0682-451c-8ee8-9ad5316022b6) | ![Upload Course](https://github.com/user-attachments/assets/21d4b1b8-c2ac-40e6-8a7f-de823434b647) |

### Categories and Notifications
| Category Page | Notification |
|---------------|--------------|
| ![Category](https://github.com/user-attachments/assets/798ddca1-fa70-40de-a60d-75a3b2042839) | ![Notification](https://github.com/user-attachments/assets/fbbf409f-5920-4ec7-9dc1-3a84d2964e90) |

### Details and Video Player
| Course Detail Page | Video Player Screen |
|--------------------|---------------------|
| ![Course Detail](https://github.com/user-attachments/assets/3c392a9b-5a7b-413e-b90d-0cf2013a87e5) | ![Video Player](https://github.com/user-attachments/assets/89024ca0-b543-4c1e-a6ef-328016008230) |

### Profile and Forgot Password
| Profile Page | Forgot Password Screen |
|--------------|-------------------------|
| ![Profile](https://github.com/user-attachments/assets/1a0fff98-1925-48e8-910d-2f6e5da5e3e7) | ![Forgot Password](https://github.com/user-attachments/assets/d045a85d-2962-417c-922d-33ebd66acdcb) |

## Docker

To build and push the Docker image for the backend, follow these steps:

1. **Build the Docker image:**
    ```bash
    docker build -t ved0702/adhyayan:tagname -p 8080:8080 .
    ```

    Here, `-p 8080:8080` maps port 8080 on your host to port 8080 in the Docker container. Adjust the port numbers as needed for your application.

2. **Push the Docker image to Docker Hub:**
    ```bash
    docker push ved0702/adhyayan:tagname
    ```

Replace `tagname` with your desired tag for the Docker image.

## Installation

To get started with the Adhyayan app, follow these steps:

### Prerequisites

- Flutter SDK
- Node.js
- MongoDB
- Cloudinary account (for media uploads)

### Setup Flutter App

1. Clone the repository:
    ```bash
    git clone https://github.com/0cyberghost0/adhyayan.git
    ```

2. Navigate to the `adhyayan` directory:
    ```bash
    cd adhyayan
    ```

3. Install dependencies:
    ```bash
    flutter pub get
    ```

4. Run the app:
    ```bash
    flutter run
    ```

### Setup Backend

1. Navigate to the `server` directory:
    ```bash
    cd server
    ```

2. Install dependencies:
    ```bash
    npm install
    ```

3. Create a `.env` file in the `server` directory and add the required environment variables (e.g., MongoDB URI, Cloudinary credentials).

4. Start the server:
    ```bash
    npm start
    ```

