import { NextFunction, Request, Response } from "express";
import { createMeetingService, joinMeetingService } from "./schedule.service";

export const createMeetingController = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { title, time, role, interviewerEmails, intervieweeEmails } = req.body;
        const { userName, userEmail } = res.locals.user;
        await createMeetingService({ userName, userEmail, title, time, role, interviewerEmails, intervieweeEmails });
        res.status(200).json({ message: "Meeting created successfully" });
    } catch (error) {
        next(error);
    }
}

export const joinMeetingController = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { meetingCode } = req.query;
        const user = res.locals.user;
        await joinMeetingService({ email: user.email, meetingCode: meetingCode as string });
        res.status(200).json({ message: "Meeting joined successfully" });
    } catch (error) {
        next(error);
    }
}