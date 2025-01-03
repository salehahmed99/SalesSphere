import express from 'express';

const router = express.Router();

// import /api/*.js
import employeeRouter from './api/employee.route.js';
import dealRouter from './api/deal.route.js';
import authRouter from './api/auth.route.js';
import businessRouter from './api/business.route.js';
import AuthController from '../controllers/auth.controller.js';
import BusinessController from '../controllers/business.controller.js';
import notificationRouter from './api/notification.route.js';
import customerRouter from './api/customer.route.js';
import adminRouter from './api/admin.route.js';
import financeRouter from './api/finance.route.js';
import targetRouter from './api/target.route.js';
import logsRouter from './api/logs.route.js';
import badgeRouter from './api/badge.route.js';

const authController = new AuthController();
const businessController = new BusinessController();

// No authentication required for these routes
// all other files in /routes/api/*.js will require authentication
router.use('/auth', authRouter);
router.post('/business/register', businessController.register);

router.use('/admin', adminRouter)

// routes with authentication required
router.use(authController.verifyToken);
router.use('/employee', employeeRouter);
router.use('/deal', dealRouter);
router.use('/business', businessRouter);
router.get('/me', authController.me);
router.use('/notification', notificationRouter);
router.use('/customer', customerRouter);
router.use('/finance', financeRouter);
router.use('/target', targetRouter);
router.use('/logs', logsRouter);
router.use('/badge', badgeRouter);

// Export the router
export default router;