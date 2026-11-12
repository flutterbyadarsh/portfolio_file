/**
 * Vercel Serverless Function for Adarsh Gupta's Portfolio Contact Form.
 * Sends emails via Resend API without exposing RESEND_API_KEY in Flutter Web.
 */

const ALLOWED_ORIGINS = new Set([
  'https://adarshgupta.info',
  'https://www.adarshgupta.info',
  'https://adarsh-portfolio-c6281.web.app',
  'https://adarsh-portfolio-c6281.firebaseapp.com',
]);

function isAllowedOrigin(origin) {
  if (!origin) return false;
  if (ALLOWED_ORIGINS.has(origin)) return true;
  return /^http:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin);
}

function setCorsHeaders(req, res) {
  const origin = req.headers.origin;
  if (isAllowedOrigin(origin)) {
    res.setHeader('Access-Control-Allow-Origin', origin);
    res.setHeader('Vary', 'Origin');
  }
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Accept');
}

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function parseJsonBody(req) {
  if (!req.body) return {};
  if (typeof req.body === 'string') {
    return JSON.parse(req.body);
  }
  return req.body;
}

module.exports = async function handler(req, res) {
  setCorsHeaders(req, res);

  if (req.method === 'OPTIONS') {
    return res.status(204).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ ok: false, error: 'Method not allowed' });
  }

  const apiKey = process.env.RESEND_API_KEY;
  if (!apiKey) {
    return res.status(500).json({
      ok: false,
      error: 'Server is missing RESEND_API_KEY environment variable',
    });
  }

  let body;
  try {
    body = parseJsonBody(req);
  } catch {
    return res.status(400).json({ ok: false, error: 'Invalid JSON payload' });
  }

  const name = String(body.name || '').trim();
  const senderEmail = String(body.email || '').trim();
  const message = String(body.message || '').trim();
  const submittedIst = String(
    body.submittedAtIst || body['Submitted Time (IST)'] || ''
  ).trim();

  if (!name || !senderEmail.includes('@') || message.length < 2) {
    return res.status(400).json({
      ok: false,
      error: 'Valid name, email, and message are required',
    });
  }

  const toEmail = process.env.CONTACT_TO_EMAIL || 'dev.adarshgupta@gmail.com';
  const fallbackFrom = 'Adarsh Portfolio <onboarding@resend.dev>';
  const preferredFrom = (process.env.RESEND_FROM_EMAIL || '').trim() || fallbackFrom;

  const safeName = escapeHtml(name);
  const safeEmail = escapeHtml(senderEmail);
  const safeMessage = escapeHtml(message).replace(/\n/g, '<br/>');
  const safeTime = escapeHtml(submittedIst || new Date().toISOString());

  async function sendResendEmail(payload) {
    const resendRes = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });
    const data = await resendRes.json().catch(() => ({}));
    return { ok: resendRes.ok, status: resendRes.status, data };
  }

  const ownerHtml = `
    <div style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden;">
      <div style="background: #0A192F; padding: 20px 24px; border-bottom: 3px solid #DC2626;">
        <h2 style="margin: 0; color: #FFFFFF; font-size: 18px;">New Portfolio Message</h2>
        <p style="margin: 4px 0 0; color: #94A3B8; font-size: 13px;">Received from adarshgupta.info</p>
      </div>
      <div style="padding: 24px; background: #FFFFFF; color: #0F172A;">
        <table style="width: 100%; border-collapse: collapse; margin-bottom: 16px;">
          <tr>
            <td style="padding: 6px 0; color: #64748B; font-size: 13px; width: 140px;"><strong>Name</strong></td>
            <td style="padding: 6px 0; font-size: 14px;">${safeName}</td>
          </tr>
          <tr>
            <td style="padding: 6px 0; color: #64748B; font-size: 13px;"><strong>Email</strong></td>
            <td style="padding: 6px 0; font-size: 14px;"><a href="mailto:${safeEmail}" style="color: #DC2626;">${safeEmail}</a></td>
          </tr>
          <tr>
            <td style="padding: 6px 0; color: #64748B; font-size: 13px;"><strong>Submitted (IST)</strong></td>
            <td style="padding: 6px 0; font-size: 13px;">${safeTime}</td>
          </tr>
        </table>
        <div style="background: #F8FAFC; border-left: 3px solid #DC2626; padding: 14px 16px; border-radius: 6px; font-size: 14px; line-height: 1.6;">
          ${safeMessage}
        </div>
      </div>
    </div>
  `;

  const autoReplyHtml = `
    <div style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden;">
      <div style="background: #0A192F; padding: 20px 24px; border-bottom: 3px solid #DC2626;">
        <h2 style="margin: 0; color: #FFFFFF; font-size: 18px;">Thank You, ${safeName}!</h2>
        <p style="margin: 4px 0 0; color: #94A3B8; font-size: 13px;">Your message was delivered to Adarsh Gupta</p>
      </div>
      <div style="padding: 24px; background: #FFFFFF; color: #0F172A; font-size: 14px; line-height: 1.65;">
        <p style="margin-top: 0;">Hi ${safeName},</p>
        <p>Thank you for reaching out through <strong>adarshgupta.info</strong>. Your message has been delivered to my inbox, and I will get back to you shortly.</p>
        <p style="margin-bottom: 6px; color: #64748B; font-size: 12.5px;"><strong>Submitted (IST):</strong> ${safeTime}</p>
        <div style="background: #F8FAFC; border-left: 3px solid #DC2626; padding: 12px 14px; border-radius: 6px; color: #334155;">
          ${safeMessage}
        </div>
        <p style="margin-bottom: 0; margin-top: 18px;">Best regards,<br/><strong>Adarsh Gupta</strong><br/><span style="color: #64748B; font-size: 12.5px;">Flutter Developer • adarshgupta.info</span></p>
      </div>
    </div>
  `;

  try {
    let usedFallbackFrom = false;
    let ownerResult = await sendResendEmail({
      from: preferredFrom,
      to: [toEmail],
      reply_to: senderEmail,
      subject: `Portfolio Contact from ${name}`,
      html: ownerHtml,
      text: `Name: ${name}\nEmail: ${senderEmail}\nSubmitted (IST): ${submittedIst || 'N/A'}\n\n${message}`,
    });

    // If custom domain DNS is still propagating in Resend, automatically fall back
    // to onboarding@resend.dev so incoming inquiries never fail in the meantime.
    if (!ownerResult.ok && preferredFrom !== fallbackFrom) {
      usedFallbackFrom = true;
      ownerResult = await sendResendEmail({
        from: fallbackFrom,
        to: [toEmail],
        reply_to: senderEmail,
        subject: `Portfolio Contact from ${name}`,
        html: ownerHtml,
        text: `Name: ${name}\nEmail: ${senderEmail}\nSubmitted (IST): ${submittedIst || 'N/A'}\n\n${message}`,
      });
    }

    if (!ownerResult.ok) {
      return res.status(ownerResult.status).json({
        ok: false,
        error: ownerResult.data.message || 'Resend API request failed',
      });
    }

    // Attempt visitor auto-reply confirmation using preferredFrom (or fallbackFrom
    // only when sending to the owner's own address). Once custom domain DNS verifies,
    // preferredFrom succeeds automatically for every external visitor email.
    let autoReplySent = false;
    let autoReplyError = null;
    try {
      const replyResult = await sendResendEmail({
        from: usedFallbackFrom ? fallbackFrom : preferredFrom,
        to: [senderEmail],
        reply_to: toEmail,
        subject: 'Thank you — your message was delivered to Adarsh Gupta',
        html: autoReplyHtml,
        text: `Hi ${name},\n\nThank you for reaching out via adarshgupta.info. Your message was delivered and I will reply shortly.\n\nSubmitted (IST): ${submittedIst || 'N/A'}\n\nBest regards,\nAdarsh Gupta`,
      });
      autoReplySent = replyResult.ok;
      if (!replyResult.ok) {
        autoReplyError = replyResult.data.message || 'Auto-reply rejected by Resend';
      }
    } catch (replyErr) {
      autoReplyError =
        replyErr instanceof Error ? replyErr.message : 'Auto-reply network error';
    }

    return res.status(200).json({
      ok: true,
      id: ownerResult.data.id || null,
      autoReplySent,
      ...(usedFallbackFrom ? { usedFallbackFrom: true } : {}),
      ...(autoReplyError ? { autoReplyNote: autoReplyError } : {}),
    });
  } catch (err) {
    return res.status(502).json({
      ok: false,
      error: err instanceof Error ? err.message : 'Network error calling Resend',
    });
  }
};
