const String BaseUrl = "https://deero-advert-production-c83e.up.railway.app";
// const String BaseUrl = "http://192.168.8.37:5000";
const String EndPoint = "${BaseUrl}/api/";
const String WHOISXML_API_KEY = "at_YxhHaYdXUyaU9qLH7w0vnZarnjRHi";

const String isLogged = "isLogged";
const String userinfo = "userinfo";

// ── Advert: social & email (FAB / links) — beddel profile-yada dhabta ah ──
const String kAdvertWhatsAppNumber = "252618553839";
const String kAdvertSocialTikTokUrl = "https://www.tiktok.com/@deeroadverts?_r=1&_t=ZS-95TiDt6Svki";
const String kAdvertSocialBehanceUrl = "https://www.behance.net/deeroadvert/";
const String kAdvertSocialInstagramUrl = "https://www.instagram.com/deeroadvert?igsh=Z24za2xsMmg4Mmxo";

String get kAdvertSocialWhatsAppUrl =>
    "https://wa.me/$kAdvertWhatsAppNumber?text=${Uri.encodeComponent("Hello Deero Advert")}";


final String enterpriseLogo = 'images/enterpriseLogo.png';
final String raadsanLogo = 'images/raadsanlogo.png';
final String advertLogo = 'images/advertimages/advertlogo.png';
final String instituteLogo = 'images/institutelogo.png';
final String fullRaadsanLogo = 'images/raadsanfulllogo.png';
final String fullAdvertLogo = 'images/advertimages/advertfulllogo.png';
final String fullInstituteLogo = 'images/institutefulllogo.png';
