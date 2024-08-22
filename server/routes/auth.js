const express=require("express");
const authRoutes=express.Router();
const User=require("../models/userModel");
const bcrypt=require("bcryptjs");
const jwt=require("jsonwebtoken");
const authMiddleWare=require("./middleware/authMiddleware");
authRoutes.post("/signup", async (req, res) => {
    try {
      const { firstName, lastName, email, password,phone} = req.body;
  
      if (!firstName || !email || !password) {
        return res.status(400).json({ error: "Please fill all required fields" });
      }
  
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res.status(400).json({ error: "User with this email already exists" });
      }
  
      const hashedPassword = await bcrypt.hash(password, 12);

      const newUser = new User({
        firstName,
        lastName,
        email,
        password: hashedPassword,
        phone,
      });

      await newUser.save();
  
      res.status(200).json({ message: "User created successfully", user: newUser });

    } catch (error) {
    
      res.status(500).json({ error: error.message });
    }
  });
  authRoutes.post("/login", async (req, res) => {
    try {
      const { email, password } = req.body;
  
      if (!email || !password) {
        return res.status(400).json({ error: "Please provide both email and password" });
      }
      
      const user = await User.findOne({ email });
      if (!user) {
        return res.status(400).json({ error: "Invalid email or password" });
      }
  
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) {
        return res.status(400).json({ error: "Invalid email or password" });
      }
  
      const token = jwt.sign({ userId: user._id }, 'jwtPassword', { expiresIn: '1h' });
  
      res.status(200).json({
        token,
        ...user._doc,
      });
  
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });
  authRoutes.post("/isTokenValid",async(req,res)=>{
        try {
            console.log("Inside TokenValid");
            const token=req.header("x-auth-token");
            console.log(token);
            if(!token) return res.json(false);
            const verified=jwt.verify(token,"jwtPassword");
            if(!verified) return res.json(false);
            const user=await User.findById(verified.userId);
            if(!user) return res.json(false);
            return res.json(true);
        
    } catch (error) {
        res.status(400).json({error:error.message});
        
    }
  });
  authRoutes.get("/getData",authMiddleWare,async(req,res)=>{
    try {
        const userId=req.user;
        const user=await User.findById(userId);
        if(!user) return res.status(400).json({error:"No User Found"});
        console.log(req.token);
        res.status(200).json({...user._doc,token:req.token});
    } catch (error) {
        res.status(500).json({error:error.message});
    }
})
  
  module.exports = authRoutes;