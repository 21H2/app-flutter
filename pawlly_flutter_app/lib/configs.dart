// ignore_for_file: constant_identifier_names
import 'package:firebase_core/firebase_core.dart';

/// ============================================================================
/// NO BACKEND MODE CONFIGURATION
/// ============================================================================
/// 
/// WARNING: Mock mode is for TESTING and DEMO purposes ONLY!
/// DO NOT use in production with real user data!
/// 
/// When USE_MOCK_DATA = true:
/// - All API calls return mock data
/// - No backend server required
/// - Data stored locally only
/// - Accepts any login credentials
/// - NO security validation
/// 
/// For production use:
/// - Set USE_MOCK_DATA = false
/// - Configure DOMAIN_URL below
/// - Ensure backend server is running
/// - Implement proper security
/// ============================================================================
const bool USE_MOCK_DATA = true;

const APP_NAME = 'Pawlly';
const APP_LOGO_URL = '$DOMAIN_URL/img/logo/mini_logo.png';
const DEFAULT_LANGUAGE = 'en';
const GREEK_LANGUAGE = 'el';
const DASHBOARD_AUTO_SLIDER_SECOND = 5;

///Live Url

///TEST URL
const DOMAIN_URL = "http://localhost:8000"; // TODO: Replace with your Laravel backend URL

const BASE_URL = '$DOMAIN_URL/api/';

//Airtel Money Payments
///It Supports ["UGX", "NGN", "TZS", "KES", "RWF", "ZMW", "CFA", "XOF", "XAF", "CDF", "USD", "XAF", "SCR", "MGA", "MWK"]
const airtel_currency_code = "MWK";
const airtel_country_code = "MW";
const AIRTEL_BASE = 'https://openapiuat.airtel.africa/'; //Test Url
// const AIRTEL_BASE = 'https://openapi.airtel.africa/'; // Live Url

//region STRIPE
const STRIPE_URL = 'https://api.stripe.com/v1/payment_intents';
const STRIPE_merchantIdentifier = "merchant.flutter.stripe.test";
const STRIPE_MERCHANT_COUNTRY_CODE = 'IN';
const STRIPE_CURRENCY_CODE = 'INR';
//endregion

//region SADAD
/// SADAD PAYMENT DETAIL
const SADAD_API_URL = 'https://api-s.sadad.qa';
const SADAD_PAY_URL = "https://d.sadad.qa";
//endregion

/// RAZORPAY
const String razorpayCurrency = "INR";

/// PAYSTACK
const String payStackCurrency = "NGN";

/// PAYPAl
const String payPalSupportedCurrency = 'USD';

const APP_PLAY_STORE_URL = '';
const APP_APPSTORE_URL = '';

const TERMS_CONDITION_URL = '$DOMAIN_URL/page/terms-conditions';
const PRIVACY_POLICY_URL = '$DOMAIN_URL/page/privacy-policy';
const INQUIRY_SUPPORT_EMAIL = 'demo@gmail.com';

/// You can add help line number here for contact. It's demo number
const HELP_LINE_NUMBER = '+15265897485';

///firebase configs
/// Refer this Step Add Firebase Option Step from the link below
/// https://apps.iqonic.design/documentation/vizion-ai-doc/build/docs/getting-started/app/Configuration/flutter#add-firebaseoptions
const FirebaseOptions firebaseConfig = FirebaseOptions(
  appId: "",
  apiKey: '',
  projectId: '',
  messagingSenderId: '',
  storageBucket: '',
  iosBundleId: '',
);
