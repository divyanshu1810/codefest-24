import cors from "cors";
import express from "express";
import bodyParser from "body-parser";
import helmet from "helmet";
import config from "../config";
import routes from "../api";
import admin from "firebase-admin";

export default ({ app }: { app: express.Application }): void => {
  app.enable("trust proxy");
  app.use(helmet());
  app.use(cors());
  app.use(bodyParser.json());
  app.use(config.api.prefix, routes());

  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
  });
};
