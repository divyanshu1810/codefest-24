import { validateRequest } from "../../shared/middlewares/valiator";
import { Router } from "express";
import { createMeetingController } from "./schedule.controller";
import { createMeetingSchema } from "./schedule.schema";
import authenticateToken from "../../shared/middlewares/authenticate";

export default (): Router => {
  const app = Router();
  app.post("/create", validateRequest("body", createMeetingSchema), authenticateToken('interviewer'), createMeetingController);
  app.get("/join", createMeetingController);
  return app;
};
