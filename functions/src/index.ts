/*
*   Send FCM push notification to mentor device for new connection.
*/

import { initializeApp } from "firebase-admin/app";
import { getDatabase } from "firebase-admin/database";
import { getMessaging } from "firebase-admin/messaging";
import { logger } from "firebase-functions";
import { onValueUpdated } from "firebase-functions/database";

initializeApp();
const db = getDatabase();
const messaging = getMessaging();

export const sendMentorNewConnectionFCM = onValueUpdated(
    "/chats/{chatId}/approved",
    async (event: any) => {

        // get mentorUid
        const chatRef = db.ref(`/chats/${event.params.chatId}`);
        let result = await chatRef.get();
        const chatInfo = result.val();

        // logger.log(chatInfo);

        // get token from users
        const mentorFCMTokenRef =
            db.ref(`/users/${chatInfo.mentorUid}/fcmToken`);
        // /users/KFTXJ70sFCg5CAxzQIkk6FzkMlp1/fcmToken
        result = await mentorFCMTokenRef.get();
        const mentorFCMToken = result.val();

        // send FCM
        // App Alert - New Matchup Available - Please Login
        const notification = {
            title: "BlackSheep",
            body: "New Matchup Available - " + (chatInfo.type === 'chat' ? "Please login" : "Check your emails")
        };

        await messaging.send({ token: String(mentorFCMToken), notification: notification });

        logger.log('Finished.')
    },
);