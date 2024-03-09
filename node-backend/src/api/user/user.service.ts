import { config } from "dotenv";
import database from "../../loaders/mongo";
import { v2 as cloudinary } from 'cloudinary';
config();

cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_KEY,
    api_secret: process.env.CLOUDINARY_SECRET
});

interface UploadResult {
    public_id: string,
    version: number,
    signature: string,
    width: number,
    height: number,
    format: string,
    resource_type: string,
    created_at: string,
    bytes: number,
    type: string,
    url: string,
    secure_url: string
}

export const handleAddProfile = async (
    files: { [fieldname: string]: Express.Multer.File[] } | Express.Multer.File[] | undefined,
    body: {
        addressLine1: string;
        addressLine2: string;
        phoneNumber: number;
    },
    email: string
) => {
    if (!files) {
        throw new Error("No file uploaded");
    } else {
        const collection = (await database()).collection("users");
        await collection.updateOne({ email }, {
            $set: {
                addressLine1: body.addressLine1,
                addressLine2: body.addressLine2,
                phoneNumber: body.phoneNumber,
            }
        });
        // Iterate through files
        if (Array.isArray(files)) {
            // If files is an array
            for (const file of files) {
                const uploadResult = await new Promise((resolve) => {
                    cloudinary.uploader.upload_stream((error, uploadResult) => {
                        return resolve(uploadResult);
                    }).end(file.buffer);
                });
                console.log(uploadResult);
                if (file.fieldname === "passportImage") {
                    await collection.updateOne({ email }, {
                        $set: {
                            passportImage: uploadResult,
                        }
                    });
                }
                if (file.fieldname === "governmentIdImage") {
                    await collection.updateOne({ email }, {
                        $set: {
                            governmentIdImage: uploadResult,
                        }
                    });
                }
            }
        } else {
            // If files is an object
            for (const fieldName in files) {
                const fieldFiles = files[fieldName];
                for (const file of fieldFiles) {
                    const uploadResult = await new Promise((resolve) => {
                        cloudinary.uploader.upload_stream((error, uploadResult) => {
                            return resolve(uploadResult);
                        }).end(file.buffer);
                    });
                    console.log(uploadResult);
                    if (file.fieldname === "passportImage") {
                        await collection.updateOne({ email }, {
                            $set: {
                                passportImage: uploadResult,
                            }
                        });
                    }
                    if (file.fieldname === "governmentIdImage") {
                        await collection.updateOne({ email }, {
                            $set: {
                                governmentIdImage: uploadResult,
                            }
                        });
                    }
                }
            }
        }
    }
};
