const mongoose = require('mongoose');
const courseSchema = mongoose.Schema({
    title: {
        type: String,
        required: true,
    },
    description: {
        type: String,
        required: true,
    },
    instructor: {
        type: String,
        required: true,
    },
    price: {
        type: Number,
        required: true,
    },
    rating: {
        type: Number,
        default: 0,
    },
    enrolledCount: {
        type: Number,
        default: 0,
    },
    thumbnailUrl: {
        type: String,
    },
    category: {
        type: String,
    },
    lessons: [{
        title: String,
        content: String,
    }],
});

const Course = mongoose.model("Course", courseSchema);
module.exports = Course;
