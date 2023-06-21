const PAYMENT_URL =
    "https://us-central1-grocapp-f4eb9.cloudfunctions.net/customFunctions/payment";

const ORDER_DATA = {
  "custID": "USER_12345",
  "custEmail": "someone@abc.com",
  "custPhone": "1212121212",
};

const STATUS_LOADING = "PAYMENT_LOADING";
const STATUS_SUCCESSFUL = "PAYMENT_SUCCESSFUL";
const STATUS_PENDING = "PAYMENT_PENDING";
const STATUS_FAILED = "PAYMENT_FAILED";
const STATUS_CHECKSUM_FAILED = "PAYMENT_CHECKSUM_FAILED";

const List<String> cities = ['Sambalpur', 'Burla', 'Hirakud'];