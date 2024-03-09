import { Request, Response, NextFunction } from "express";
import { loginService, signupService } from "./auth.service";

export const signupController = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { role, token, name, email } = await signupService({
      name: req.body.name,
      role: req.body.role,
      email: req.body.email,
      password: req.body.password,
      deviceToken: req.body.deviceToken,
    });
    res.status(201).send({
      success: true,
      message: "User created successfully!",
      data: { role, token, name, email },
    });
  } catch (error) {
    next(error);
  }
};

export const loginController = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const {name, email, token, role} = await loginService({
      email: req.body.email,
      password: req.body.password,
      deviceToken: req.body.deviceToken,
    });
    res.status(200).send({
      success: true,
      message: "User logged in successfully!",
      data: { name, email, token, role },
    });
  } catch (error) {
    next(error);
  }
};
