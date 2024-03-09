import { customAlphabet } from "nanoid";
import admin from "firebase-admin";
import database from "../../loaders/mongo";
export const createMeetingService = async (params: {
  userName: string;
  userEmail: string;
  title: string;
  time: unknown;
  role: string;
  interviewerEmails: string[];
  intervieweeEmails: string[];
}): Promise<void> => {
  type AndroidData = {
    [key: string]: { title: string; body: string; imageUrl: string };
  };
  const {
    userName,
    userEmail,
    title,
    time,
    role,
    interviewerEmails,
    intervieweeEmails,
  } = params;
  const nanoid = customAlphabet("abcdefghijklmnopqrstuvwxyz", 9);
  const collection = (await database()).collection("schedules");
  const body = `${userName} has invited you to a meeting at ${time}`;
  const imageUrl =
    "https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png";
  const androidData: AndroidData = {
    notification: {
      title: `Invite to {title}`,
      body: body,
      imageUrl: imageUrl,
    },
    data: {
      title: title,
      body: body,
      imageUrl: imageUrl,
    },
  };
  // I want mongodb to return only the tokens field from each user
  const participants = await (
    await database()
  )
    .collection("users")
    .find({ email: { $in: [...interviewerEmails, ...intervieweeEmails] } })
    .toArray();
  const tokenarrays = [participants.map((participant) => participant.deviceTokens)];
  const tokens = tokenarrays.flat();
  for (const token of tokens)
    await admin.messaging().send({
      token: token,
      notification: {
        title: title,
        body: body,
        imageUrl: imageUrl,
      },
      android: {
        notification: {
          imageUrl: imageUrl,
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
          },
        },
      },
      data: "data" in androidData ? androidData.data : undefined,
    });
  await collection.insertOne({
    time,
    meetingCode: nanoid(),
    createdBy: userName,
    intervierwerEmails: [userEmail, ...interviewerEmails],
    title,
    role,
    intervieweeEmails: intervieweeEmails,
    createdAt: new Date(),
    updatedAt: new Date(),
    isDeleted: false,
  });

  return;
};

export const joinMeetingService = async (params: {
  email: string;
  meetingCode: string;
}): Promise<void> => {
  const { email, meetingCode } = params;

  const collection = (await database()).collection("schedules");
  // join only if the meeting is not deleted and time is only 1 hour before
  // Get current time
  const currentTime = new Date();
  const meeting = await collection.findOne({
    meetingCode,
    attendees: email,
    isDeleted: false,
    time: {
      $gte: new Date(currentTime.getTime() - 60 * 60 * 1000),
    },
  });
  if (!meeting) {
    throw new Error("Meeting not found");
  }
  return;
};
