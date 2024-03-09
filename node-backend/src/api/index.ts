import { Router } from "express";
import authRouter from "./auth/auth.router";
import scheduleRouter from "./schedule/schedule.router";
import userRouter from "./user/user.router";

export default (): Router => {
    const app = Router();
    app.use('/auth', authRouter());
    app.use('/schedule', scheduleRouter());
    app.use('/user', userRouter());
    return app;
};