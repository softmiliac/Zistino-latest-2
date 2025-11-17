class APIEndpoint {
  static const String _generalURL = "https://recycle.metadatads.com";
  static const String signalRUrl = "https://recycle.metadatads.com/notifications";
  // static const String _generalURL = "https://api.gouyaa.com";
  static const String apiBaseURL = "$_generalURL/api/";
  static const String mediaURL = _generalURL;
  static const String uploadURL = "$_generalURL/api/";

//****************************Defaults ****************************//
  static const String insert = "";
  static const String getByID = "getByID";
  static const String search = "search";
  static const String profile = "profile";
  static const String file = "folder=app";
  // https://api.keenflous.nl/api/v1/personal/profile
//****************************Custom ****************************//
  static const String getByCategoryType = "client-view-by-categorytype";
  static const String client = "client";
  static const String clientSlug = "client/byslug";
  static const String anonymousClient = "anonymous-client";
  static const String myRequests = "myrequests";
  static const String userbyrole = "userbyrole";
  // POST
  // /api/tokens/token-by-code-confirmation
  // static const String codeConfirmation = "token-by-code-confirmation";

  static const String sendCode = "send-code?phoneNumber=";
  static const String commentsByProductId = "commentsbyproductidasync";
  static const String orders = "client/search";
  static const String validationConfirmationCode = "tokenbycode";
  static const String getAllProducts = "search-by-sp";
  static const String clientByUserId = "client/by-userid";
  static const String bookmark = "bookmark";
  static const String addresses = "addresses";
  static const String address = "address";
  static const String basket = "basket";
  static const String loginByPhoneNumber = "token-by-code";
  // POST
  // /api/identity/register-with-code
  static const String register = "register-with-code";
  static const String byCategoryType2 = "client/by-type/2";
  static const String categoryType = "client/by-categorytype/2";


  static const String forgotPassword = "forgot-password-by-code";
  static const String resetPassword = "reset-password-by-code";
  static const String checkCodeForgotPassword = "check-reset-password-code";
  static const String validateEmail = "check-duplicate";
  static const String home = "by-page?page=HOME";
  static const String byGroupName = "by-group-name?groupName=herbs";
  static const String pharmacy = "by-page?page=h5";
  static const String byCategoryID = "by-categoryid";
  // static const String home = "by-page?page=h";
  static const String pageView = "page-view";
  static const String byProductID = "byproductid";
  static const String offerte = "offerte";
  static const String followUp = "followup";
  static const String searchBySp = "search-by-sp";
  static const String coupons = "applycoupononbasket";
  static const String anonymousRepairRequest = "anonymous-client";
  static const String numberRepairStatus = "numberofrepairrequestsinstatus";
  static const String myTransactionWalletTotal = "mytransactionwallettotal";
  static const String myTransactionWalletHistory = "mytransactionwallethistory";


  static String urlCreator(APIControllers controller, String endPoint,
      {String version = "v1", String? id,String? slug}) {
    String url;
    if (version.isNotEmpty) {
      url = "$version/${controller.name}";
    }else{
      url = controller.name;
    }



    if (endPoint.isNotEmpty) {
      url = "$url/$endPoint";
    }


    if (id != null) {
      url = "$url/$id";
    }
    if (slug != null) {
      url = "$url/$slug";
    }
    return url;
  }
}

enum APIControllers {
  addresses,
  adsItem,
  adsZones,
  auditLogs,
  baskets,
  blogCategories,
  blogposts,
  blogTags,
  bookmarks,
  brands,
  categories,
  cms,
  colors,
  comments,
  coupons,
  couponsUses,
  faqs,
  fileManager,
  fileUploader,
  identity,
  likes,
  localizations,
  mailTemplates,
  orders,
  payments,
  personal,
  popularProducts,
  problems,
  productProblems,
  products,
  productSections,
  productSpecifications,
  repairRequestArchives,
  repairRequests,
  roleClaims,
  roles,
  stats,
  tags,
  tenants,
  testimonials,
  tickets,
  tokens,
  users,
  warranties,
  contactusmessages,
  driverdelivery,
  transactionwallet,
  vehicle,
  locations,
  trip,

}
