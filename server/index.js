const express = require('express');
const app = express();
const dotenv = require('dotenv');
const colors = require('colors');
dotenv.config(); //To access/config the DB connection token

//import routes
const authRoute = require('./routes/auth');
const addProductRoute = require('./routes/addProduct');
const deleteProductRoute = require('./routes/deleteProduct');
const pdfRoute = require('./routes/pdf');
const searchRoute = require('./routes/search');
const stockRoute = require('./routes/stock_in_out');
const logger = require('./routes/logger');
dotenv.config();

//Connect to DB
const connectDB = require('./config/db');
connectDB();
const port = process.env.PORT;

//Middleware
app.use(express.json());
app.use(logger);

//Route Middlewares
app.use('/api/search', searchRoute);
app.use('/api/oauth', authRoute);
app.use('/api/addProduct', addProductRoute);
app.use('/api/deleteProduct', deleteProductRoute);
app.use('/api/pdf', pdfRoute);
app.use('/api/stock',stockRoute);

app.listen(port, () =>
	console.log(`Server is running on port ${port}`.yellow.bold)
);
