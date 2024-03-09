import dotenv from 'dotenv';
dotenv.config();
//process.env.NODE_ENV = process.env.NODE_ENV || 'development';

export default {
    port: parseInt(process.env.PORT as string, 10) || 3000,
    databaseUrl: process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/dbname',
    jwtSecret: process.env.JWT_SECRET,
    firebase: {
        key_url: process.env.FIRE_SECRET_URL!,
        key_path: process.env.GOOGLE_APPLICATION_CREDENTIALS!,
    },
    logs: {
        level: process.env.LOG_LEVEL || 'silly',
    },
    api: {
        prefix: '/api',
    },
}