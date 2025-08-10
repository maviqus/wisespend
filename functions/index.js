// Gen2 Functions (HTTP only) using v2 API
const { onRequest } = require('firebase-functions/v2/https');
const { setGlobalOptions } = require('firebase-functions/v2');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

admin.initializeApp();
setGlobalOptions({ region: 'us-central1', invoker: 'public' }); // make HTTP endpoints publicly callable

// Environment variables: set MAIL_USER / MAIL_PASS in functions runtime config or env
// firebase functions:config:set mail.user="..." mail.pass="..."
let mailUser = process.env.MAIL_USER;
let mailPass = process.env.MAIL_PASS;
try {
    // Attempt firebase functions config fallback if available
    if (!mailUser || !mailPass) {
        const legacyConfig = require('firebase-functions').config();
        mailUser = mailUser || legacyConfig.mail?.user;
        mailPass = mailPass || legacyConfig.mail?.pass;
    }
} catch (_) {}

let transporter = null;
if (mailUser && mailPass) {
    transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: { user: mailUser, pass: mailPass },
    });
}

// Rate limit config: max 5 code sends per email per 15 minutes
const RATE_LIMIT_WINDOW_MS = 15 * 60 * 1000;
const RATE_LIMIT_MAX = 5;

function allowCors(req, res) {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Headers', 'Content-Type');
    res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
    if (req.method === 'OPTIONS') {
        res.status(204).send('');
        return false;
    }
    return true;
}

exports.getCustomToken = onRequest(async (req, res) => {
    if (!allowCors(req, res)) return;
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
    const uid = req.body.uid || req.query.uid;
    if (!uid) return res.status(400).json({ error: 'Missing uid' });
    try {
        const customToken = await admin.auth().createCustomToken(uid);
        res.json({ token: customToken });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

exports.sendResetCodeHttp = onRequest(async (req, res) => {
    if (!allowCors(req, res)) return;
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
    try {
        const email = (req.body?.email || '').toLowerCase().trim();
        if (!email) return res.status(400).json({ error: 'Email không hợp lệ' });

        // Rate limiting per email
        const attemptsRef = admin.firestore().collection('password_reset_attempts').doc(email);
        const now = Date.now();
        const attemptSnap = await attemptsRef.get();
        let attempts = [];
        if (attemptSnap.exists) {
            const data = attemptSnap.data();
            attempts = Array.isArray(data.attempts) ? data.attempts.filter(ts => typeof ts === 'number') : [];
        }
        // Filter attempts within window
        attempts = attempts.filter(ts => now - ts < RATE_LIMIT_WINDOW_MS);
        if (attempts.length >= RATE_LIMIT_MAX) {
            const retryAfterSec = Math.ceil((RATE_LIMIT_WINDOW_MS - (now - attempts[0])) / 1000);
            return res.status(429).json({ error: 'Quá nhiều lần gửi, thử lại sau', retryAfter: retryAfterSec });
        }

        const code = Math.floor(100000 + Math.random() * 900000).toString();
        const expiresAt = Date.now() + 10 * 60 * 1000;
        await admin.firestore().collection('password_reset_codes').doc(email).set({
            code,
            expiresAt,
            createdAt: new Date().toISOString(),
        });

        // Record this attempt (append & prune old)
        attempts.push(now);
        try {
            await attemptsRef.set({ attempts }, { merge: true });
        } catch (e) {
            console.warn('Could not record rate-limit attempt', e);
        }
            if (!transporter) {
                console.warn('Email transporter not configured - refusing to leak code');
                return res.status(500).json({ error: 'Dịch vụ email chưa cấu hình' });
            }
        await transporter.sendMail({
            from: `WiseSpend <${mailUser}>`,
            to: email,
            subject: 'Mã đặt lại mật khẩu',
            html: `<p>Xin chào,</p><p>Mã xác minh đặt lại mật khẩu của bạn là: <b>${code}</b></p><p>Mã sẽ hết hạn sau 10 phút.</p>`
        });
        res.json({ success: true });
    } catch (e) {
        console.error('sendResetCodeHttp error', e);
        res.status(500).json({ error: 'Internal error' });
    }
});

exports.verifyResetCodeHttp = onRequest(async (req, res) => {
    if (!allowCors(req, res)) return;
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
    try {
        const email = (req.body?.email || '').toLowerCase().trim();
        const code = (req.body?.code || '').trim();
        if (!email || !code) return res.status(400).json({ error: 'Thiếu email hoặc mã' });
        const ref = await admin.firestore().collection('password_reset_codes').doc(email).get();
        if (!ref.exists) return res.status(404).json({ error: 'Mã không tồn tại' });
        const dataDoc = ref.data();
        if (dataDoc.code !== code) return res.status(403).json({ error: 'Mã không đúng' });
        if (Date.now() > dataDoc.expiresAt) return res.status(410).json({ error: 'Mã đã hết hạn' });
        res.json({ success: true });
    } catch (e) {
        console.error('verifyResetCodeHttp error', e);
        res.status(500).json({ error: 'Internal error' });
    }
});

exports.changePasswordWithCodeHttp = onRequest(async (req, res) => {
    if (!allowCors(req, res)) return;
    if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
    try {
        const email = (req.body?.email || '').toLowerCase().trim();
        const code = (req.body?.code || '').trim();
        const newPassword = (req.body?.newPassword || '').trim();
        if (!email || !code || !newPassword) return res.status(400).json({ error: 'Thiếu tham số' });
        if (newPassword.length < 6) return res.status(422).json({ error: 'Mật khẩu phải từ 6 ký tự' });
        const snap = await admin.firestore().collection('password_reset_codes').doc(email).get();
        if (!snap.exists) return res.status(404).json({ error: 'Mã không tồn tại' });
        const dataDoc = snap.data();
        if (dataDoc.code !== code) return res.status(403).json({ error: 'Mã không đúng' });
        if (Date.now() > dataDoc.expiresAt) return res.status(410).json({ error: 'Mã đã hết hạn' });
        const userRecord = await admin.auth().getUserByEmail(email);
        await admin.auth().updateUser(userRecord.uid, { password: newPassword });
        await admin.firestore().collection('password_reset_codes').doc(email).delete();
        res.json({ success: true });
    } catch (e) {
        console.error('changePasswordWithCodeHttp error', e);
        res.status(500).json({ error: 'Internal error' });
    }
});

