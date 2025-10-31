/*
*   Send FCM push notification to mentor device for new connection.
*/

import { initializeApp } from "firebase-admin/app";
import { getDatabase } from "firebase-admin/database";
import { getMessaging } from "firebase-admin/messaging";
import { onValueCreated } from "firebase-functions/database";

initializeApp();
const db = getDatabase();
const messaging = getMessaging();

export const sendMentorNewConnectionFCM = onValueCreated(
    "/chat/{pushId}",
    async (event: any) => {
        // get token from users
        const tokenRef =
            db.ref(`/users/${event.value['mentorId']}/fcmToken`);
        const fcmToken = await tokenRef.get();

        // send FCM
        // App Alert - New Matchup Available - Please Login
        const notification = {
            title: "BlackSheep",
            body: "New Matchup Available - " + event.value['type'] === 'chat' ? "Please login" : "Check your emails"
        };

        await messaging.send({ token: String(fcmToken), notification: notification });
    },
);