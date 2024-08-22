const express=require("express");
const Course=require("../models/courseModel");
const courseRouter=express();
courseRouter.get("/popularCourse", async (req, res) => {
    try {
        console.log("inside popular");
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
module.exports=courseRouter;