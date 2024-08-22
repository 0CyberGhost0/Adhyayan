const express=require("express");
const cors=require("cors");

const app=express();
app.use(cors());
const connectDB=require("./db");
const authRoutes = require("./routes/auth");
require("dotenv").config();
const PORT=process.env.PORT;
connectDB();
app.use(express.json());
app.get("/",async(req,res)=>{
    res.json({"msg":"Hello World"});
});
app.use("/auth",authRoutes);
app.listen(PORT,async(req,res)=>{
    console.log(`Listening on Port ${PORT}`);
});