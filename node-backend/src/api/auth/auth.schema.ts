import { z } from "zod";

export const signupSchema = z.object({
  name: z.string().min(3),
  // role can only be 'admin' or 'user'
  role: z.string().regex(/^(interviewer|interviewee)$/),
  email: z.string().email(),
  password: z.string().min(8),
  deviceToken: z.string().min(1).optional(),
});

export const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  deviceToken: z.string().min(1).optional(),
});
