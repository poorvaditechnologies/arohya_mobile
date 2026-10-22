/// Every Kannada (ಕನ್ನಡ) string in the app lives in this one file.
///
/// **Format:** `'English text': 'ಕನ್ನಡ ಪಠ್ಯ'`. The English text is exactly the
/// string passed to `context.tr('...')` in the code, so to add or change a
/// translation you only edit this file. Rules:
///  * Keep `{placeholders}` (e.g. `{email}`, `{count}`) in the Kannada text.
///  * A missing entry is not an error: the app falls back to the English text.
///  * Brand names (Arohya, AROHYA CAPITAL), sample data and symbols are
///    intentionally not translated.
///
/// NOTE: these translations are a first draft and should be reviewed by a
/// native Kannada speaker before release.
library;

const Map<String, String> kannadaStrings = {
  // ─── Splash ─────────────────────────────────────────────────────────
  'SOVEREIGN SYNDICATE ARCHITECTURE': 'ಸಾರ್ವಭೌಮ ಸಿಂಡಿಕೇಟ್ ವಾಸ್ತುಶಿಲ್ಪ',
  'Securing statutory cryptographic conduit...':
      'ಕಾನೂನುಬದ್ಧ ಕ್ರಿಪ್ಟೋಗ್ರಾಫಿಕ್ ಮಾರ್ಗವನ್ನು ಭದ್ರಪಡಿಸಲಾಗುತ್ತಿದೆ...',
  'Establishing Encrypted Enclave...':
      'ಎನ್‌ಕ್ರಿಪ್ಟ್ ಮಾಡಿದ ಸುರಕ್ಷಿತ ವಲಯವನ್ನು ಸ್ಥಾಪಿಸಲಾಗುತ್ತಿದೆ...',

  // ─── Onboarding ─────────────────────────────────────────────────────
  'Skip': 'ಬಿಟ್ಟುಬಿಡಿ',
  'PRIORITY CORRIDOR': 'ಆದ್ಯತಾ ಮಾರ್ಗ',
  'PRE-APPROVED BUSINESS QUANTUM': 'ಪೂರ್ವ-ಅನುಮೋದಿತ ವ್ಯಾಪಾರ ಮೊತ್ತ',
  'up to ': 'ಗರಿಷ್ಠ ',
  'Collateral-free credit facility with risk-adjusted underwriting':
      'ಅಪಾಯ-ಹೊಂದಾಣಿಕೆಯ ಅಂಡರ್‌ರೈಟಿಂಗ್‌ನೊಂದಿಗೆ ಜಾಮೀನು-ರಹಿತ ಸಾಲ ಸೌಲಭ್ಯ',
  'Sovereign Capital for Indian Enterprises':
      'ಭಾರತೀಯ ಉದ್ಯಮಗಳಿಗೆ ಸಾರ್ವಭೌಮ ಬಂಡವಾಳ',
  'Fast-track institutional lending with zero hard credit bureau inquiries and algorithmic syndicate match within 4 hours.':
      'ಹಾರ್ಡ್ ಕ್ರೆಡಿಟ್ ಬ್ಯೂರೋ ವಿಚಾರಣೆ ಇಲ್ಲದೆ ಮತ್ತು 4 ಗಂಟೆಗಳೊಳಗೆ ಅಲ್ಗಾರಿದಮಿಕ್ ಸಿಂಡಿಕೇಟ್ ಹೊಂದಾಣಿಕೆಯೊಂದಿಗೆ ವೇಗದ ಸಾಂಸ್ಥಿಕ ಸಾಲ.',
  'Institutional Framework & Safeguards': 'ಸಾಂಸ್ಥಿಕ ಚೌಕಟ್ಟು ಮತ್ತು ಸುರಕ್ಷತೆಗಳು',
  'Tap to collapse regulatory details':
      'ನಿಯಂತ್ರಕ ವಿವರಗಳನ್ನು ಮುಚ್ಚಲು ಟ್ಯಾಪ್ ಮಾಡಿ',
  'Tap to read more on RBI, AA & KFS compliance':
      'RBI, AA ಮತ್ತು KFS ಅನುಸರಣೆ ಕುರಿತು ಹೆಚ್ಚು ಓದಲು ಟ್ಯಾಪ್ ಮಾಡಿ',
  'Show less': 'ಕಡಿಮೆ ತೋರಿಸಿ',
  'Read more': 'ಇನ್ನಷ್ಟು ಓದಿ',
  'RBI Regulated Guidelines 2022 Compliant':
      'RBI ನಿಯಂತ್ರಿತ ಮಾರ್ಗಸೂಚಿಗಳು 2022 ಗೆ ಅನುಗುಣ',
  'Direct fiduciary adherence to digital lending protocols and safe custody mandates.':
      'ಡಿಜಿಟಲ್ ಸಾಲ ನೀಡಿಕೆ ಪ್ರೋಟೋಕಾಲ್‌ಗಳು ಮತ್ತು ಸುರಕ್ಷಿತ ಪಾಲನೆ ಆದೇಶಗಳಿಗೆ ನೇರ ಫಿಡ್ಯೂಷಿಯರಿ ಬದ್ಧತೆ.',
  'Account Aggregator Direct Integration': 'ಅಕೌಂಟ್ ಅಗ್ರಿಗೇಟರ್ ನೇರ ಏಕೀಕರಣ',
  'Encrypted zero-tamper GST and bank statements fetching in under 90 seconds.':
      'ಎನ್‌ಕ್ರಿಪ್ಟ್ ಮಾಡಿದ, ತಿದ್ದುಪಡಿ-ರಹಿತ GST ಮತ್ತು ಬ್ಯಾಂಕ್ ಸ್ಟೇಟ್‌ಮೆಂಟ್‌ಗಳು 90 ಸೆಕೆಂಡುಗಳೊಳಗೆ ಪಡೆಯುವಿಕೆ.',
  'Transparent Key Fact Statements (KFS)':
      'ಪಾರದರ್ಶಕ ಪ್ರಮುಖ ಸಂಗತಿ ಹೇಳಿಕೆಗಳು (KFS)',
  'Zero concealed charges, upfront APR disclosure, and no prepayment penalties.':
      'ಯಾವುದೇ ಗುಪ್ತ ಶುಲ್ಕಗಳಿಲ್ಲ, ಮುಂಚಿತವಾಗಿ APR ಬಹಿರಂಗಪಡಿಸುವಿಕೆ ಮತ್ತು ಮುಂಪಾವತಿ ದಂಡವಿಲ್ಲ.',
  'Get Started / Create Account': 'ಪ್ರಾರಂಭಿಸಿ / ಖಾತೆ ತೆರೆಯಿರಿ',
  'Already have an account? ': 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ? ',

  // ─── Login ──────────────────────────────────────────────────────────
  'Please enter a valid email address':
      'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ ಇಮೇಲ್ ವಿಳಾಸವನ್ನು ನಮೂದಿಸಿ',
  'Verification code sent to {email}': '{email} ಗೆ ಪರಿಶೀಲನಾ ಕೋಡ್ ಕಳುಹಿಸಲಾಗಿದೆ',
  'Could not send verification code: {error}':
      'ಪರಿಶೀಲನಾ ಕೋಡ್ ಕಳುಹಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ: {error}',
  'Authentication successful. Welcome Rajesh!':
      'ದೃಢೀಕರಣ ಯಶಸ್ವಿಯಾಗಿದೆ. ಸ್ವಾಗತ ರಾಜೇಶ್!',
  'Login failed: {error}': 'ಲಾಗಿನ್ ವಿಫಲವಾಗಿದೆ: {error}',
  'Signed in with Google. Welcome Rajesh!':
      'Google ನೊಂದಿಗೆ ಸೈನ್ ಇನ್ ಆಗಿದೆ. ಸ್ವಾಗತ ರಾಜೇಶ್!',
  'Google sign in failed': 'Google ಸೈನ್ ಇನ್ ವಿಫಲವಾಗಿದೆ',
  '256-Bit SSL': '256-ಬಿಟ್ SSL',
  'SECURE CLIENT GATEWAY': 'ಸುರಕ್ಷಿತ ಗ್ರಾಹಕ ಗೇಟ್‌ವೇ',
  'Welcome Back': 'ಮರಳಿ ಸ್ವಾಗತ',
  'Sign in to access your credit facilities and active applications.':
      'ನಿಮ್ಮ ಸಾಲ ಸೌಲಭ್ಯಗಳು ಮತ್ತು ಸಕ್ರಿಯ ಅರ್ಜಿಗಳನ್ನು ವೀಕ್ಷಿಸಲು ಸೈನ್ ಇನ್ ಮಾಡಿ.',
  'Email OTP': 'ಇಮೇಲ್ OTP',
  'Password / MPIN': 'ಪಾಸ್‌ವರ್ಡ್ / MPIN',
  'Registered Email Address': 'ನೋಂದಾಯಿತ ಇಮೇಲ್ ವಿಳಾಸ',
  'One-Time Password will be emailed to this address.':
      'ಒಂದು-ಬಾರಿಯ ಪಾಸ್‌ವರ್ಡ್ ಅನ್ನು ಈ ವಿಳಾಸಕ್ಕೆ ಇಮೇಲ್ ಮಾಡಲಾಗುತ್ತದೆ.',
  'Use the email address linked to your account.':
      'ನಿಮ್ಮ ಖಾತೆಗೆ ಲಿಂಕ್ ಆಗಿರುವ ಇಮೇಲ್ ವಿಳಾಸವನ್ನು ಬಳಸಿ.',
  'Password or 6-digit MPIN': 'ಪಾಸ್‌ವರ್ಡ್ ಅಥವಾ 6-ಅಂಕಿಯ MPIN',
  'Sign in with Biometrics': 'ಬಯೋಮೆಟ್ರಿಕ್ಸ್‌ನೊಂದಿಗೆ ಸೈನ್ ಇನ್ ಮಾಡಿ',
  'Active': 'ಸಕ್ರಿಯ',
  'Enabled for Rajesh Kumar Gowda':
      'ರಾಜೇಶ್ ಕುಮಾರ್ ಗೌಡ ಅವರಿಗೆ ಸಕ್ರಿಯಗೊಳಿಸಲಾಗಿದೆ',
  'Remember this device for 30 days': 'ಈ ಸಾಧನವನ್ನು 30 ದಿನಗಳವರೆಗೆ ನೆನಪಿಡಿ',
  'Get Secure OTP': 'ಸುರಕ್ಷಿತ OTP ಪಡೆಯಿರಿ',
  'Sign In': 'ಸೈನ್ ಇನ್',
  'OR': 'ಅಥವಾ',
  'Continue with Google': 'Google ನೊಂದಿಗೆ ಮುಂದುವರಿಸಿ',
  "Don't have an account? ": 'ಖಾತೆ ಇಲ್ಲವೇ? ',
  'Create Account': 'ಖಾತೆ ತೆರೆಯಿರಿ',
  'Having trouble signing in? ': 'ಸೈನ್ ಇನ್ ಮಾಡಲು ತೊಂದರೆಯಾಗುತ್ತಿದೆಯೇ? ',
  'Contact Fiduciary Support': 'ಫಿಡ್ಯೂಷಿಯರಿ ಬೆಂಬಲವನ್ನು ಸಂಪರ್ಕಿಸಿ',

  // ─── Signup ─────────────────────────────────────────────────────────
  'Please enter your full legal name':
      'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಪೂರ್ಣ ಕಾನೂನುಬದ್ಧ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
  'Please enter a valid 10-digit PAN number':
      'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ 10-ಅಕ್ಷರದ PAN ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
  'Please accept the statutory consent items to proceed':
      'ಮುಂದುವರಿಯಲು ಕಾನೂನುಬದ್ಧ ಒಪ್ಪಿಗೆ ಅಂಶಗಳನ್ನು ಒಪ್ಪಿಕೊಳ್ಳಿ',
  'Google account linked. Welcome Rajesh!':
      'Google ಖಾತೆ ಲಿಂಕ್ ಆಗಿದೆ. ಸ್ವಾಗತ ರಾಜೇಶ್!',
  'Google sign up failed': 'Google ನೋಂದಣಿ ವಿಫಲವಾಗಿದೆ',
  'Create Borrower Account': 'ಸಾಲಗಾರರ ಖಾತೆ ತೆರೆಯಿರಿ',
  'Empowering MSMEs and business owners with transparent institutional credit.':
      'ಪಾರದರ್ಶಕ ಸಾಂಸ್ಥಿಕ ಸಾಲದ ಮೂಲಕ MSME ಮತ್ತು ವ್ಯಾಪಾರ ಮಾಲೀಕರನ್ನು ಸಬಲಗೊಳಿಸುವುದು.',
  'Full Legal Name (As per PAN)': 'ಪೂರ್ಣ ಕಾನೂನುಬದ್ಧ ಹೆಸರು (PAN ಪ್ರಕಾರ)',
  'Must match your PAN card record': 'ನಿಮ್ಮ PAN ಕಾರ್ಡ್ ದಾಖಲೆಗೆ ಹೊಂದಿಕೆಯಾಗಬೇಕು',
  'Email Address': 'ಇಮೇಲ್ ವಿಳಾಸ',
  "We'll email a 6-digit verification code":
      'ನಾವು 6-ಅಂಕಿಯ ಪರಿಶೀಲನಾ ಕೋಡ್ ಅನ್ನು ಇಮೇಲ್ ಮಾಡುತ್ತೇವೆ',
  "I agree to Arohya Capital's Terms of Service, Privacy Policy, and RBI Digital Lending Fair Practice Code.":
      'ನಾನು ಆರೋಹ್ಯ ಕ್ಯಾಪಿಟಲ್‌ನ ಸೇವಾ ನಿಯಮಗಳು, ಗೌಪ್ಯತಾ ನೀತಿ ಮತ್ತು RBI ಡಿಜಿಟಲ್ ಸಾಲ ನೀಡಿಕೆ ನ್ಯಾಯಯುತ ಅಭ್ಯಾಸ ಸಂಹಿತೆಯನ್ನು ಒಪ್ಪುತ್ತೇನೆ.',
  'Consent to fetch credit report via Account Aggregator / Bureau ':
      'ಅಕೌಂಟ್ ಅಗ್ರಿಗೇಟರ್ / ಬ್ಯೂರೋ ಮೂಲಕ ಕ್ರೆಡಿಟ್ ವರದಿ ಪಡೆಯಲು ಒಪ್ಪಿಗೆ ',
  '(Soft Inquiry only, no bureau score impact).':
      '(ಸಾಫ್ಟ್ ವಿಚಾರಣೆ ಮಾತ್ರ, ಬ್ಯೂರೋ ಸ್ಕೋರ್ ಮೇಲೆ ಪರಿಣಾಮವಿಲ್ಲ).',
  'Continue': 'ಮುಂದುವರಿಸಿ',
  'Sign up with Google': 'Google ನೊಂದಿಗೆ ನೋಂದಾಯಿಸಿ',
  'Already registered? ': 'ಈಗಾಗಲೇ ನೋಂದಾಯಿಸಿದ್ದೀರಾ? ',
  '256-BIT SSL ENCRYPTED': '256-ಬಿಟ್ SSL ಎನ್‌ಕ್ರಿಪ್ಟ್ ಮಾಡಲಾಗಿದೆ',

  // ─── Email OTP ──────────────────────────────────────────────────────
  'Verify Your Email': 'ನಿಮ್ಮ ಇಮೇಲ್ ಪರಿಶೀಲಿಸಿ',
  'Enter the 6-digit code we sent to':
      'ನಾವು ಕಳುಹಿಸಿರುವ 6-ಅಂಕಿಯ ಕೋಡ್ ಅನ್ನು ನಮೂದಿಸಿ',
  "Didn't receive the code? ": 'ಕೋಡ್ ಬರಲಿಲ್ಲವೇ? ',
  'Resend code': 'ಕೋಡ್ ಮತ್ತೆ ಕಳುಹಿಸಿ',
  'Resend in {time}': '{time} ನಲ್ಲಿ ಮತ್ತೆ ಕಳುಹಿಸಿ',
  'Verify & Sign In': 'ಪರಿಶೀಲಿಸಿ ಮತ್ತು ಸೈನ್ ಇನ್ ಮಾಡಿ',
  'Register & Verify OTP': 'ನೋಂದಾಯಿಸಿ ಮತ್ತು OTP ಪರಿಶೀಲಿಸಿ',
  'Change email address': 'ಇಮೇಲ್ ವಿಳಾಸ ಬದಲಾಯಿಸಿ',
  'A new verification code has been sent': 'ಹೊಸ ಪರಿಶೀಲನಾ ಕೋಡ್ ಕಳುಹಿಸಲಾಗಿದೆ',
  'Enter the complete 6-digit code': 'ಪೂರ್ಣ 6-ಅಂಕಿಯ ಕೋಡ್ ಅನ್ನು ನಮೂದಿಸಿ',
  'Incorrect code. Please try again.':
      'ತಪ್ಪಾದ ಕೋಡ್. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
  'Authentication successful. Welcome back!':
      'ದೃಢೀಕರಣ ಯಶಸ್ವಿಯಾಗಿದೆ. ಮರಳಿ ಸ್ವಾಗತ!',
  'Account created! Welcome to Arohya Capital.':
      'ಖಾತೆ ರಚನೆಯಾಗಿದೆ! ಆರೋಹ್ಯ ಕ್ಯಾಪಿಟಲ್‌ಗೆ ಸ್ವಾಗತ.',
  'Registration failed: {error}': 'ನೋಂದಣಿ ವಿಫಲವಾಗಿದೆ: {error}',

  // ─── Home: shell & dashboard ────────────────────────────────────────
  'Home': 'ಮುಖಪುಟ',
  'Loans': 'ಸಾಲಗಳು',
  'Support': 'ಬೆಂಬಲ',
  'Profile': 'ಪ್ರೊಫೈಲ್',
  'No new notifications': 'ಹೊಸ ಅಧಿಸೂಚನೆಗಳಿಲ್ಲ',
  'Good morning, ': 'ಶುಭೋದಯ, ',
  'Fiduciary Tier 1 Verified': 'ಫಿಡ್ಯೂಷಿಯರಿ ಶ್ರೇಣಿ 1 ಪರಿಶೀಲಿಸಲಾಗಿದೆ',
  'Secure Rail': 'ಸುರಕ್ಷಿತ ಮಾರ್ಗ',
  'Browsing verified institutional credit options...':
      'ಪರಿಶೀಲಿತ ಸಾಂಸ್ಥಿಕ ಸಾಲ ಆಯ್ಕೆಗಳನ್ನು ಬ್ರೌಸ್ ಮಾಡಲಾಗುತ್ತಿದೆ...',
  'Opening Stage 4 Bureau Validation details...':
      'ಹಂತ 4 ಬ್ಯೂರೋ ಮೌಲ್ಯೀಕರಣ ವಿವರಗಳನ್ನು ತೆರೆಯಲಾಗುತ್ತಿದೆ...',
  'Starting fresh institutional loan application...':
      'ಹೊಸ ಸಾಂಸ್ಥಿಕ ಸಾಲ ಅರ್ಜಿಯನ್ನು ಪ್ರಾರಂಭಿಸಲಾಗುತ್ತಿದೆ...',
  'Tracking active application #ARH10294...':
      'ಸಕ್ರಿಯ ಅರ್ಜಿ #ARH10294 ಅನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಲಾಗುತ್ತಿದೆ...',
  'Connecting with Arohya Fiduciary Desk...':
      'ಆರೋಹ್ಯ ಫಿಡ್ಯೂಷಿಯರಿ ಡೆಸ್ಕ್‌ಗೆ ಸಂಪರ್ಕಿಸಲಾಗುತ್ತಿದೆ...',
  'AROHYA FACILITATION': 'ಆರೋಹ್ಯ ಸೌಲಭ್ಯ',
  'What are you looking for?': 'ನೀವು ಏನನ್ನು ಹುಡುಕುತ್ತಿದ್ದೀರಿ?',
  'Your financial journey, simplified. Institutional credit structures tailored for growth.':
      'ನಿಮ್ಮ ಹಣಕಾಸು ಪ್ರಯಾಣ, ಸರಳೀಕೃತ. ಬೆಳವಣಿಗೆಗೆ ತಕ್ಕಂತೆ ರೂಪಿಸಿದ ಸಾಂಸ್ಥಿಕ ಸಾಲ ರಚನೆಗಳು.',
  'Explore financing options': 'ಹಣಕಾಸು ಆಯ್ಕೆಗಳನ್ನು ಅನ್ವೇಷಿಸಿ',
  'Multi-Lender Access': 'ಬಹು-ಸಾಲದಾತ ಪ್ರವೇಶ',
  '18+ Banking Partners': '18+ ಬ್ಯಾಂಕಿಂಗ್ ಪಾಲುದಾರರು',
  'APPLICATION #ARH10294': 'ಅರ್ಜಿ #ARH10294',
  'Partner Review': 'ಪಾಲುದಾರರ ಪರಿಶೀಲನೆ',
  'Sanction Requested': 'ಕೋರಿದ ಮಂಜೂರಾತಿ',
  'Stage 4 of 7: Bureau Validation Complete':
      'ಹಂತ 4/7: ಬ್ಯೂರೋ ಮೌಲ್ಯೀಕರಣ ಪೂರ್ಣಗೊಂಡಿದೆ',
  'Updated today at 09:40 AM': 'ಇಂದು ಬೆಳಿಗ್ಗೆ 09:40 ಕ್ಕೆ ನವೀಕರಿಸಲಾಗಿದೆ',
  'View Tracker': 'ಟ್ರ್ಯಾಕರ್ ವೀಕ್ಷಿಸಿ',
  'Quick Actions': 'ತ್ವರಿತ ಕ್ರಿಯೆಗಳು',
  'Direct Services': 'ನೇರ ಸೇವೆಗಳು',
  'Apply Now': 'ಈಗ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ',
  'Track App': 'ಅರ್ಜಿ ಟ್ರ್ಯಾಕ್ ಮಾಡಿ',
  'Talk to Us': 'ನಮ್ಮೊಂದಿಗೆ ಮಾತನಾಡಿ',
  'Arohya Capital • Smart Financial Solutions':
      'ಆರೋಹ್ಯ ಕ್ಯಾಪಿಟಲ್ • ಸ್ಮಾರ್ಟ್ ಹಣಕಾಸು ಪರಿಹಾರಗಳು',
  'Regulated under RBI Digital Lending Guidelines 2022 • 256-Bit SSL Encrypted':
      'RBI ಡಿಜಿಟಲ್ ಸಾಲ ನೀಡಿಕೆ ಮಾರ್ಗಸೂಚಿಗಳು 2022 ರ ಅಡಿಯಲ್ಲಿ ನಿಯಂತ್ರಿತ • 256-ಬಿಟ್ SSL ಎನ್‌ಕ್ರಿಪ್ಟ್ ಮಾಡಲಾಗಿದೆ',

  // ─── Home: financing solutions cards ────────────────────────────────
  // (card titles double as the loan types in the Apply Loan dropdown)
  'Financing Solutions': 'ಹಣಕಾಸು ಪರಿಹಾರಗಳು',
  'Pre-vetted lending pipelines': 'ಪೂರ್ವ-ಪರಿಶೀಲಿತ ಸಾಲ ಮಾರ್ಗಗಳು',
  '{count} Offerings': '{count} ಕೊಡುಗೆಗಳು',
  'View Less': 'ಕಡಿಮೆ ನೋಡಿ',
  'View More Solutions ({count} more)':
      'ಇನ್ನಷ್ಟು ಪರಿಹಾರಗಳನ್ನು ನೋಡಿ (ಇನ್ನೂ {count})',
  'Personal Loan': 'ವೈಯಕ್ತಿಕ ಸಾಲ',
  'Up to ₹40 Lakhs': '₹40 ಲಕ್ಷದವರೆಗೆ',
  'Instant KYC': 'ತ್ವರಿತ KYC',
  'From 10.49% p.a.': 'ವಾರ್ಷಿಕ 10.49% ರಿಂದ',
  'Business Loan': 'ವ್ಯಾಪಾರ ಸಾಲ',
  'Up to ₹50 Lakhs': '₹50 ಲಕ್ಷದವರೆಗೆ',
  'High Limit': 'ಹೆಚ್ಚಿನ ಮಿತಿ',
  'From 11.75% p.a.': 'ವಾರ್ಷಿಕ 11.75% ರಿಂದ',
  'Home Loan': 'ಗೃಹ ಸಾಲ',
  'Custom limits': 'ಕಸ್ಟಮ್ ಮಿತಿಗಳು',
  'Long Tenure': 'ದೀರ್ಘ ಅವಧಿ',
  'From 8.50% p.a.': 'ವಾರ್ಷಿಕ 8.50% ರಿಂದ',
  'Vehicle Loan': 'ವಾಹನ ಸಾಲ',
  'Up to 90% on-road': 'ಆನ್-ರೋಡ್ ಬೆಲೆಯ 90% ವರೆಗೆ',
  'New & Pre-owned': 'ಹೊಸ ಮತ್ತು ಹಳೆಯ ವಾಹನ',
  'From 8.90% p.a.': 'ವಾರ್ಷಿಕ 8.90% ರಿಂದ',
  'Against Property': 'ಆಸ್ತಿ ಮೇಲಿನ ಸಾಲ',
  'Up to ₹5 Crores': '₹5 ಕೋಟಿವರೆಗೆ',
  'Collateralized': 'ಜಾಮೀನು ಸಹಿತ',
  'From 9.15% p.a.': 'ವಾರ್ಷಿಕ 9.15% ರಿಂದ',
  'Educational loan': 'ಶಿಕ್ಷಣ ಸಾಲ',
  'Up to ₹1.5 Crores': '₹1.5 ಕೋಟಿವರೆಗೆ',
  'Career Growth': 'ವಿದ್ಯಾಭ್ಯಾಸದಲ್ಲಿ ಪ್ರಗತಿ',
  'From 9.75% p.a.': 'ವಾರ್ಷಿಕ 9.75% ರಿಂದ',
  'SHCG': 'SHCG',
  'Tailored support': 'ಅಗತ್ಯಕ್ಕೆ ತಕ್ಕ ಬೆಂಬಲ',
  'Inclusive Credit': 'ಒಳಗೊಳ್ಳುವ ಸಾಲ',
  'Custom pricing': 'ಕಸ್ಟಮ್ ಬೆಲೆ',
  'Insurance': 'ವಿಮೆ',
  'Custom coverage': 'ಕಸ್ಟಮ್ ವಿಮಾ ರಕ್ಷಣೆ',
  'Protection': 'ರಕ್ಷಣೆ',
  'Flexible plans': 'ಹೊಂದಿಕೊಳ್ಳುವ ಯೋಜನೆಗಳು',

  // ─── Loans tab ──────────────────────────────────────────────────────
  'Active Facilities & History': 'ಸಕ್ರಿಯ ಸೌಲಭ್ಯಗಳು ಮತ್ತು ಇತಿಹಾಸ',
  'Institutional credit portfolio and facility sanctions.':
      'ಸಾಂಸ್ಥಿಕ ಸಾಲ ಪೋರ್ಟ್‌ಫೋಲಿಯೊ ಮತ್ತು ಸೌಲಭ್ಯ ಮಂಜೂರಾತಿಗಳು.',
  'Apply for Additional Line': 'ಹೆಚ್ಚುವರಿ ಸೌಲಭ್ಯಕ್ಕೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ',
  'Pre-vetted institutional syndicate pipelines available with 4-hour sanctions.':
      '4 ಗಂಟೆಗಳ ಮಂಜೂರಾತಿಯೊಂದಿಗೆ ಪೂರ್ವ-ಪರಿಶೀಲಿತ ಸಾಂಸ್ಥಿಕ ಸಿಂಡಿಕೇಟ್ ಮಾರ್ಗಗಳು ಲಭ್ಯವಿದೆ.',
  'Explore New Credit Facility': 'ಹೊಸ ಸಾಲ ಸೌಲಭ್ಯವನ್ನು ಅನ್ವೇಷಿಸಿ',
  'TOTAL SANCTIONED CREDIT': 'ಒಟ್ಟು ಮಂಜೂರಾದ ಸಾಲ',
  '{status} Facility': '{status} ಸೌಲಭ್ಯ',
  'Next EMI: {date} • ₹{amount}': 'ಮುಂದಿನ EMI: {date} • ₹{amount}',
  'Auto-Debit Active': 'ಸ್ವಯಂ-ಡೆಬಿಟ್ ಸಕ್ರಿಯ',

  // ─── Apply loan ─────────────────────────────────────────────────────
  'Apply for Loan': 'ಸಾಲಕ್ಕೆ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ',
  'Loan Application': 'ಸಾಲದ ಅರ್ಜಿ',
  'Tell us a little about yourself and our team will take it from here.':
      'ನಿಮ್ಮ ಬಗ್ಗೆ ಸ್ವಲ್ಪ ತಿಳಿಸಿ, ಉಳಿದದ್ದನ್ನು ನಮ್ಮ ತಂಡ ನೋಡಿಕೊಳ್ಳುತ್ತದೆ.',
  'First Name': 'ಮೊದಲ ಹೆಸರು',
  'Last Name': 'ಕೊನೆಯ ಹೆಸರು',
  'Mobile Number': 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ',
  'Email Address (optional)': 'ಇಮೇಲ್ ವಿಳಾಸ (ಐಚ್ಛಿಕ)',
  'Income (optional)': 'ಆದಾಯ (ಐಚ್ಛಿಕ)',
  'Enter income amount': 'ಆದಾಯದ ಮೊತ್ತವನ್ನು ನಮೂದಿಸಿ',
  'Loan Needed Date (optional)': 'ಸಾಲ ಅಗತ್ಯವಿರುವ ದಿನಾಂಕ (ಐಚ್ಛಿಕ)',
  'Select a date': 'ದಿನಾಂಕವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
  'Permanent Address': 'ಶಾಶ್ವತ ವಿಳಾಸ',
  'House / flat no., street, city, state, PIN':
      'ಮನೆ / ಫ್ಲಾಟ್ ಸಂಖ್ಯೆ, ರಸ್ತೆ, ನಗರ, ರಾಜ್ಯ, ಪಿನ್',
  'Temporary Address': 'ತಾತ್ಕಾಲಿಕ ವಿಳಾಸ',
  'Where you currently stay': 'ನೀವು ಪ್ರಸ್ತುತ ವಾಸಿಸುವ ಸ್ಥಳ',
  'Same as permanent address': 'ಶಾಶ್ವತ ವಿಳಾಸದಂತೆಯೇ',
  'Loan Type': 'ಸಾಲದ ಪ್ರಕಾರ',
  'Select loan type': 'ಸಾಲದ ಪ್ರಕಾರವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
  'Auto-filled from the facility you selected':
      'ನೀವು ಆಯ್ಕೆ ಮಾಡಿದ ಸೌಲಭ್ಯದಿಂದ ಸ್ವಯಂ ಭರ್ತಿ',
  'Submit Application': 'ಅರ್ಜಿ ಸಲ್ಲಿಸಿ',
  'Enter first name': 'ಮೊದಲ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
  'Enter last name': 'ಕೊನೆಯ ಹೆಸರನ್ನು ನಮೂದಿಸಿ',
  'Enter a valid first name (letters only)':
      'ಮಾನ್ಯವಾದ ಮೊದಲ ಹೆಸರನ್ನು ನಮೂದಿಸಿ (ಅಕ್ಷರಗಳು ಮಾತ್ರ)',
  'Enter a valid last name (letters only)':
      'ಮಾನ್ಯವಾದ ಕೊನೆಯ ಹೆಸರನ್ನು ನಮೂದಿಸಿ (ಅಕ್ಷರಗಳು ಮಾತ್ರ)',
  'Enter mobile number': 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ',
  'Mobile number must be 10 digits': 'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ 10 ಅಂಕೆಗಳಿರಬೇಕು',
  'Mobile number must start with 6, 7, 8 or 9':
      'ಮೊಬೈಲ್ ಸಂಖ್ಯೆ 6, 7, 8 ಅಥವಾ 9 ರಿಂದ ಪ್ರಾರಂಭವಾಗಬೇಕು',
  'Enter a valid email address': 'ಮಾನ್ಯವಾದ ಇಮೇಲ್ ವಿಳಾಸವನ್ನು ನಮೂದಿಸಿ',
  'Enter permanent address': 'ಶಾಶ್ವತ ವಿಳಾಸವನ್ನು ನಮೂದಿಸಿ',
  'Enter temporary address': 'ತಾತ್ಕಾಲಿಕ ವಿಳಾಸವನ್ನು ನಮೂದಿಸಿ',
  'Address looks too short - add street, city and PIN':
      'ವಿಳಾಸ ತುಂಬಾ ಚಿಕ್ಕದಾಗಿದೆ - ರಸ್ತೆ, ನಗರ ಮತ್ತು ಪಿನ್ ಸೇರಿಸಿ',
  'Please select a loan type': 'ದಯವಿಟ್ಟು ಸಾಲದ ಪ್ರಕಾರವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
  '{loanType} application {number} submitted.':
      '{loanType} ಅರ್ಜಿ {number} ಸಲ್ಲಿಸಲಾಗಿದೆ.',
  'Submission failed: {error}': 'ಸಲ್ಲಿಕೆ ವಿಫಲವಾಗಿದೆ: {error}',

  // ─── Support ────────────────────────────────────────────────────────
  'Fiduciary Support Desk': 'ಫಿಡ್ಯೂಷಿಯರಿ ಬೆಂಬಲ ಡೆಸ್ಕ್',
  'Direct access to institutional relationship managers and credit advisors.':
      'ಸಾಂಸ್ಥಿಕ ಸಂಬಂಧ ವ್ಯವಸ್ಥಾಪಕರು ಮತ್ತು ಸಾಲ ಸಲಹೆಗಾರರಿಗೆ ನೇರ ಪ್ರವೇಶ.',
  'Senior Fiduciary Relationship Manager': 'ಹಿರಿಯ ಫಿಡ್ಯೂಷಿಯರಿ ಸಂಬಂಧ ವ್ಯವಸ್ಥಾಪಕ',
  'Available 09:00 - 19:00 IST': 'ಲಭ್ಯ: 09:00 - 19:00 IST',
  'Institutional Helpline': 'ಸಾಂಸ್ಥಿಕ ಸಹಾಯವಾಣಿ',
  '+91 80 4920 1800 (Toll Free)': '+91 80 4920 1800 (ಟೋಲ್ ಫ್ರೀ)',
  'Priority WhatsApp Desk': 'ಆದ್ಯತೆಯ ವಾಟ್ಸಾಪ್ ಡೆಸ್ಕ್',
  'Direct RM chat with document support': 'ದಾಖಲೆ ಬೆಂಬಲದೊಂದಿಗೆ ನೇರ RM ಚಾಟ್',
  'Fiduciary Grievance Officer': 'ಫಿಡ್ಯೂಷಿಯರಿ ಕುಂದುಕೊರತೆ ಅಧಿಕಾರಿ',
  'Schedule Call with Credit Underwriter':
      'ಕ್ರೆಡಿಟ್ ಅಂಡರ್‌ರೈಟರ್ ಜೊತೆ ಕರೆ ನಿಗದಿಪಡಿಸಿ',

  // ─── Profile ────────────────────────────────────────────────────────
  'C-KYC Verified Entity': 'C-KYC ಪರಿಶೀಲಿತ ಘಟಕ',
  'Security & Consent': 'ಭದ್ರತೆ ಮತ್ತು ಒಪ್ಪಿಗೆ',
  'Biometric Unlock': 'ಬಯೋಮೆಟ್ರಿಕ್ ಅನ್‌ಲಾಕ್',
  'Fingerprint and Face ID authentication':
      'ಫಿಂಗರ್‌ಪ್ರಿಂಟ್ ಮತ್ತು ಫೇಸ್ ಐಡಿ ದೃಢೀಕರಣ',
  'Change MPIN': 'MPIN ಬದಲಾಯಿಸಿ',
  'Update your 6-digit access PIN': 'ನಿಮ್ಮ 6-ಅಂಕಿಯ ಪ್ರವೇಶ ಪಿನ್ ಅನ್ನು ನವೀಕರಿಸಿ',
  'Sign Out of Session': 'ಸೆಷನ್‌ನಿಂದ ಸೈನ್ ಔಟ್ ಮಾಡಿ',
  'You have been securely signed out.':
      'ನಿಮ್ಮನ್ನು ಸುರಕ್ಷಿತವಾಗಿ ಸೈನ್ ಔಟ್ ಮಾಡಲಾಗಿದೆ.',
};
