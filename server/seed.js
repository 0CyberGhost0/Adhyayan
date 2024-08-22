const mongoose = require('mongoose');
const Course = require("./models/courseModel");
require("dotenv").config();
// Connect to MongoDB
mongoose.connect(process.env.MONGO_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => {
  console.log('Connected to MongoDB');
}).catch((err) => {
  console.error('Error connecting to MongoDB:', err);
});

// Seed Data
const seedCourses = [
  {
    title: 'Introduction to Design',
    description: 'Learn the basics of design principles and how to apply them.',
    instructor: 'John Doe',
    price: 29.99,
    rating: 4.5,
    enrolledCount: 200,
    thumbnailUrl: 'https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724362040/courseImage/nxwwl7tycp25ttqzoz6s.png',
    category: 'Design',
    lessons: [
      { title: 'Design Basics', content: 'Introduction to design concepts.' },
      { title: 'Color Theory', content: 'Understanding color theory.' },
    ],
  },
  {
    title: 'Advanced Coding in JavaScript',
    description: 'Master advanced JavaScript concepts and patterns.',
    instructor: 'Jane Smith',
    price: 49.99,
    rating: 4.7,
    enrolledCount: 300,
    thumbnailUrl: 'https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724362040/courseImage/nxwwl7tycp25ttqzoz6s.png',
    category: 'Code',
    lessons: [
      { title: 'Asynchronous JavaScript', content: 'Understanding async and await.' },
      { title: 'JavaScript Design Patterns', content: 'Exploring design patterns.' },
    ],
  },
  {
    title: 'Business Strategy Essentials',
    description: 'Develop a winning business strategy for your company.',
    instructor: 'Richard Roe',
    price: 39.99,
    rating: 4.8,
    enrolledCount: 150,
    thumbnailUrl: 'https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724362040/courseImage/nxwwl7tycp25ttqzoz6s.png',
    category: 'Business',
    lessons: [
      { title: 'Strategic Planning', content: 'Basics of strategic planning.' },
      { title: 'Market Analysis', content: 'How to analyze markets effectively.' },
    ],
  },
  {
    title: 'Data Science with Python',
    description: 'Learn data science concepts and how to apply them using Python.',
    instructor: 'Alice Johnson',
    price: 59.99,
    rating: 4.9,
    enrolledCount: 400,
    thumbnailUrl: 'https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724362040/courseImage/nxwwl7tycp25ttqzoz6s.png',
    category: 'Data',
    lessons: [
      { title: 'Data Analysis', content: 'Performing data analysis with Python.' },
      { title: 'Machine Learning', content: 'Introduction to machine learning.' },
    ],
  },
  {
    title: 'Finance for Non-Finance Managers',
    description: 'Understand the basics of finance to manage your business effectively.',
    instructor: 'Mark White',
    price: 44.99,
    rating: 4.6,
    enrolledCount: 250,
    thumbnailUrl: 'https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724362040/courseImage/nxwwl7tycp25ttqzoz6s.png',
    category: 'Finance',
    lessons: [
      { title: 'Financial Statements', content: 'Understanding financial statements.' },
      { title: 'Budgeting and Forecasting', content: 'How to create budgets and forecasts.' },
    ],
  },
  // Add 5 more courses similarly...
  {
    title: 'User Experience Design',
    description: 'Learn the principles of user experience design to create better products.',
    instructor: 'Emily Clark',
    price: 34.99,
    rating: 4.3,
    enrolledCount: 180,
    thumbnailUrl: 'https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724362040/courseImage/nxwwl7tycp25ttqzoz6s.png',
    category: 'Design',
    lessons: [
      { title: 'Introduction to UX', content: 'Understanding user experience.' },
      { title: 'User Research', content: 'Conducting user research.' },
    ],
  },
  {
    title: 'Full-Stack Web Development',
    description: 'Become a full-stack web developer by learning frontend and backend technologies.',
    instructor: 'Michael Brown',
    price: 69.99,
    rating: 4.9,
    enrolledCount: 500,
    thumbnailUrl: 'https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724362040/courseImage/nxwwl7tycp25ttqzoz6s.png',
    category: 'Code',
    lessons: [
      { title: 'Frontend Development', content: 'Learning HTML, CSS, and JavaScript.' },
      { title: 'Backend Development', content: 'Building REST APIs with Node.js.' },
    ],
  },
  {
    title: 'Startup Entrepreneurship',
    description: 'Learn how to start and grow your own business.',
    instructor: 'Sarah Lee',
    price: 54.99,
    rating: 4.8,
    enrolledCount: 280,
    thumbnailUrl: 'https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724362040/courseImage/nxwwl7tycp25ttqzoz6s.png',
    category: 'Business',
    lessons: [
      { title: 'Business Planning', content: 'How to create a business plan.' },
      { title: 'Funding Your Startup', content: 'Understanding startup funding.' },
    ],
  },
  {
    title: 'Data Visualization with Tableau',
    description: 'Learn how to create stunning data visualizations using Tableau.',
    instructor: 'Chris Green',
    price: 39.99,
    rating: 4.7,
    enrolledCount: 220,
    thumbnailUrl: 'https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724362040/courseImage/nxwwl7tycp25ttqzoz6s.png',
    category: 'Data',
    lessons: [
      { title: 'Introduction to Tableau', content: 'Getting started with Tableau.' },
      { title: 'Advanced Visualizations', content: 'Creating advanced visualizations.' },
    ],
  },
  {
    title: 'Personal Finance Management',
    description: 'Take control of your finances with practical tips and strategies.',
    instructor: 'Laura King',
    price: 29.99,
    rating: 4.5,
    enrolledCount: 300,
    thumbnailUrl: 'https://res.cloudinary.com/dxa9xqx3t/image/upload/v1724362040/courseImage/nxwwl7tycp25ttqzoz6s.png',
    category: 'Finance',
    lessons: [
      { title: 'Budgeting Basics', content: 'How to create a personal budget.' },
      { title: 'Investing for Beginners', content: 'Introduction to investing.' },
    ],
  },
];

// Insert Seed Data
const seedDB = async () => {
  try {
    await Course.deleteMany({}); // Clear existing data
    await Course.insertMany(seedCourses); // Insert new data
    console.log('Seed data inserted successfully');
  } catch (err) {
    console.error('Error seeding data:', err);
  } finally {
    mongoose.connection.close();
  }
};

seedDB();
