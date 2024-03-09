import { NextFunction, Request, Response } from "express";
import { handleAddProfile } from "./user.service";

export const addProfileController = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
        await handleAddProfile(req.files, req.body, res.locals.user.email);
        res.status(200).send({
            success: true,
            message: "Profile updated successfully!",
        });
    } catch (error) {
        next(error);
    }
}