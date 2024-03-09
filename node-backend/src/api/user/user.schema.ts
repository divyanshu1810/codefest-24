import { z } from "zod";

export const createUserDetailsSchema = z.object({
    addressLine1: z.string(),
    addressLine2: z.string(),
    phoneNumber: z.number().max(10),
    passportImage: z.string(),
    governmentIdImage: z.string(),
});