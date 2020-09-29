class mApiController {
  static String base_url = "https://bybrisk.com/apiV1/deliveryboys_module/";
  final String deliveryLogin = base_url + "config/login.php";
  final String deliverySignup = base_url + "config/signup.php";
  final String isVerified = base_url + "config/docsVerifed.php";
  final String uploadDocs = base_url + "config/uploadDocuments.php";

  //------------FETCH DELIVERY AS PER AREA---------------------
  final String pendingWithArea =
      base_url + "fetch/PendingareaListwithCount.php";
  final String deliverWithArea =
      base_url + "fetch/ReadyForDeliverareaListwithCount.php";
  final String pending = base_url + "fetch/pending.php";
  final String delivered = base_url + "fetch/shipping.php";
  final String pendingToPicked = base_url + "config/updateToPicked.php";
  final String shippingToDelivered = base_url + "config/updateToDelivered.php";
}
