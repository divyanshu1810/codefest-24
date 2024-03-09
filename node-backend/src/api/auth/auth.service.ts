import generateToken from "../../shared/jwt";
import database from "../../loaders/mongo";
import bcrypt from "bcrypt";
// returns an object with role and token
export const signupService = async (params: {
  name: string;
  role: string;
  email: string;
  password: string;
  deviceToken: string;
}): Promise<{
  role: string;
  token: string;
  email: string;
  name: string;
  deviceToken: string;
}> => {
  const collection = (await database()).collection("users");
  const exists = await collection.findOne({ email: params.email });
  if (exists) throw new Error("User already exists");
  const saltRounds = 10;
  const hash = await bcrypt.hash(params.password, saltRounds);
  await collection.insertOne({
    name: params.name,
    email: params.email,
    role: params.role,
    password: hash,
    deviceTokens: [params.deviceToken],
    registeredAt: new Date(),
    updatedAt: new Date(),
    isDeleted: false,
  });

  return {
    role: params.role,
    token: generateToken(params.email),
    name: params.name,
    email: params.email,
    deviceToken: params.deviceToken,
  };
};

// Service for user login

export const loginService = async (params: {
  email: string;
  password: string;
  deviceToken: string;
}): Promise<{
  role: string;
  token: string;
  name: string;
  email: string;
  deviceToken: string;
  userImage: string;
}> => {
  const collection = (await database()).collection("users");
  // push device token to array
  const user = await collection.findOneAndUpdate({ email: params.email }, {
    $push: { deviceTokens: params.deviceToken } as any
  });
  if (!user) throw new Error("User does not exist");
  const match = await bcrypt.compare(params.password, user.password);
  if (!match) throw new Error("Incorrect password");
  return {
    role: user.role,
    token: generateToken(params.email),
    name: user.name,
    email: user.email,
    deviceToken: params.deviceToken,
    userImage: user.passportImage.url,
  };
};
