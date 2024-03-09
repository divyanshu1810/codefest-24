// import authenticateToken from "@/shared/middlewares/authenticate";
import { validateRequest } from "../../shared/middlewares/valiator";
import { Router } from "express";
import { createUserDetailsSchema } from "./user.schema";
import { addProfileController } from "./user.controller";
import { upload } from "../../shared/multer";
import authenticateToken from "../../shared/middlewares/authenticate";

export default (): Router => {
    const app = Router();
    app.post("/addprofile",
        // validateRequest(
        //     'body',
        //     createUserDetailsSchema
        // ),
        upload.fields([
            { name: 'passportImage', maxCount: 1 },
            { name: 'governmentIdImage', maxCount: 1 }
        ]), authenticateToken('interviewee'), addProfileController);
    return app;
};