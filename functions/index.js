/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.getCustomToken = functions.https.onRequest(async (req, res) => {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Headers', 'Content-Type');
    if (req.method === 'OPTIONS') {
        res.status(204).send('');
        return;
    }

    const uid = req.body.uid || req.query.uid;
    if (!uid) {
        return res.status(400).json({ error: 'Missing uid' });
    }
    try {
        const customToken = await admin.auth().createCustomToken(uid);
        res.json({ token: customToken });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
