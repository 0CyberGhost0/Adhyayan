const mongoose = require('mongoose');

const userSchema = mongoose.Schema({
  firstName: {
    type: String,
    required: true,
    trim: true,
  },
  lastName: {
    type: String,
    trim: true,
  },
  email: {
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
  password: {
    type: String,
    required: true,
  },
  phone: {
    type: String,
    required: true,
  },
  userType: {
    type: String,
    enum: ["Student", "Mentor"],
    default: "Student",
  },
  isVerified: {
    type: Boolean,
    default: false,
  },
  profileImageUrl: {
    type: String,
    trim: true,
    default: 'https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724310891/profileImage/jb2yekqpwv61rkh9wlpu.png',
  },
  purchasedCourses: {
    type: [
      {
        courseId: {
          type: mongoose.Schema.Types.ObjectId,
          ref: 'Course',
          required: true,
        },
        completedLessonNo: {
          type: Number,
          default: 0,
        },
      },
    ],
    default: [],
  },
  savedCourses: {
    type: [
      {
        courseId: {
          type: mongoose.Schema.Types.ObjectId,
          ref: 'Course',
          required: true,
        },
        savedAt: {
          type: Date,
          default: Date.now,
        },
      },
    ],
    default: [],
  },
});

const User = mongoose.model("User", userSchema);
module.exports = User;
