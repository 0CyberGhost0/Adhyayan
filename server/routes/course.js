const express=require("express");
const Course=require("../models/courseModel");
const authMiddleware=require("../routes/middleware/authMiddleware");
const User=require("../models/userModel");
const courseRouter=express();
courseRouter.get("/popularCourse", async (req, res) => {
    try {
        const popularCourses = await Course.find({})
            .sort({ rating: -1 }) // Sort courses by rating in descending order
            .limit(10); // Limit the results to 10 courses

        res.status(200).json(popularCourses);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

courseRouter.get("/category/:categoryType", async (req, res) => {
    try {
        const { categoryType } = req.params;

        const courses = await Course.find({ category: categoryType });

        if (courses.length === 0) {
            return res.status(404).json({ message: "No courses found for this category." });
        }

        res.status(200).json(courses);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
courseRouter.post("/saveCourse", authMiddleware, async (req, res) => {
    try {
        const userId = req.user; // Assuming authMiddleware adds the user ID to req.user
        const { courseId } = req.body;

        // Find the user by ID
        const user = await User.findById(userId);

        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }

        // Check if the course is already saved
        const isCourseSaved = user.savedCourses.some(
            (savedCourse) => savedCourse.courseId.toString() === courseId
        );

        if (isCourseSaved) {
            return res.status(400).json({ message: "Course is already saved" });
        }

        // Add the course to the savedCourses array
        user.savedCourses.push({ courseId });
        await user.save();

        res.status(200).json({ message: "Course saved successfully" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});
courseRouter.post("/unsaveCourse", authMiddleware, async (req, res) => {
    try {
        const userId = req.user; // Assuming authMiddleware adds the user ID to req.user
        const { courseId } = req.body;

        // Find the user by ID
        const user = await User.findById(userId);

        if (!user) {
            return res.status(404).json({ error: "User not found" });
        }

        // Check if the course is saved
        const isCourseSaved = user.savedCourses.some(
            (savedCourse) => savedCourse.courseId.toString() === courseId
        );

        // if (!isCourseSaved) {
        //     return res.status(400).json({ message: "Course is not saved" });
        // }

        // Remove the course from the savedCourses array
        user.savedCourses = user.savedCourses.filter(
            (savedCourse) => savedCourse.courseId.toString() !== courseId
        );

        await user.save();

        res.status(200).json({ message: "Course removed from saved courses" });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});
courseRouter.get("/search/:searchText",async(req,res)=>{
    try {
        const searchText=req.params.searchText;
     
        if(!searchText ||searchText.length==0){
            return res.status(400).json({error:"Enter Text to Search"});
        }

        const course = await Course.find({
            $or: [
              { title: { $regex: searchText, $options: "i" } },   // Search in title
              { description: { $regex: searchText, $options: "i" } },  // Search in decription 
              { category: { $regex: searchText, $options: "i" } },   // Search in category
              { instructor: { $regex: searchText, $options: "i" } }, //search in instructor
            ],
        }); 
          res.status(200).json(course);
        
    } catch (error) {
        res.status(500).json({error:error.message});
    }
})

courseRouter.get("/getCourseDetail",async(req,res)=>{
    try {
        console.log("INSIDE COURSE DETAIL");
        const courseId=req.header("courseId");
        console.log(courseId);
        const course=await Course.findById(courseId);
        return res.status(200).json(course);
        
    } catch (error) {
        res.status(500).json({error:error.message});
        
    }
});
courseRouter.post("/enrollCourse", authMiddleware, async (req, res) => {
    try {
      console.log("inside enroll");
      
      // Get the userId from the auth middleware and courseId from the request headers
      const userId = req.user; 
      const courseId = req.header("courseId");
  
      // Fetch the user from the database
      const user = await User.findById(userId);
  
      // Check if the user is already enrolled in the course
      const isAlreadyEnrolled = user.enrolledCourses.some(
        (course) => course.courseId.toString() === courseId
      );
  
      if (isAlreadyEnrolled) {
        return res.status(400).json({ message: "User is already enrolled in this course." });
      }
  
      // Add the course to the enrolledCourses array
      user.enrolledCourses.push({ courseId });
  
      // Save the updated user document
      await user.save();
  
      return res.status(200).json({ message: "User successfully enrolled in the course." });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: error.message });
    }
  });
  courseRouter.get("/isEnrolled",authMiddleware,async(req,res)=>{
    try {
        console.log("check enroll");
        const userId=req.user;
        const courseId=req.header("courseId");
        const user=await User.findById(userId);
        const isAlreadyEnrolled = user.enrolledCourses.some(
            (course) => course.courseId.toString() === courseId
          );
          return res.status(200).json(isAlreadyEnrolled);
    } catch (error) {
        console.log(error);
        res.status(500).json(false);
        
    }

  })
module.exports=courseRouter;