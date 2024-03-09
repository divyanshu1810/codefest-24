import express from "./express";
import mongo from "./mongo";
import Express from "express";
import LoggerInstance from "./logger";
import { getSecrets } from "./fireKey";

export default async ({ expressApp}: { expressApp: Express.Application }): Promise<void> => {
    await mongo();
    LoggerInstance.info("MongoDB Intialized");
    await getSecrets();
    LoggerInstance.info("Firebase Secrets Loaded");
    // wait for 3 seconds
    await new Promise(resolve => setTimeout(resolve, 2000));
    await express({ app: expressApp });
    LoggerInstance.info("Express App Intialized");
    LoggerInstance.info("All modules loaded!");
};