import { validateRequest } from "../../shared/middlewares/valiator";
import { Router } from "express";
import { loginSchema, signupSchema } from "./auth.schema";
import { loginController, signupController } from "./auth.controller";

export default (): Router => {
  const app = Router();
  app.post("/signup", validateRequest("body", signupSchema), signupController);
  app.post("/login", validateRequest("body", loginSchema), loginController);
  return app;
};
