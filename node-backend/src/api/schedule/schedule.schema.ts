import { z } from "zod";

export const createMeetingSchema = z.object({
  title: z.string(),
  time: z.any(),
  role: z.string(),
  interviewerEmails: z.array(z.string().email()).optional(),
  intervieweeEmails: z.array(z.string().email()),
});
