  // Include the Twilio Cloud Module and initialize it
var twilio = require("twilio");
twilio.initialize("TWILIO_KEY","TWILIO_ID");
 
// Create the Cloud Function
Parse.Cloud.define("inviteWithTwilio", function(request, response) {
  // Use the Twilio Cloud Module to send an SMS
  twilio.sendSMS({
    From: "+TWILIO_NUMBER_HERE",
    To: request.params.number,
    Body: request.params.verify
  }, {
    success: function(httpResponse) { response.success("SMS sent!"); },
    error: function(httpResponse) { response.error("Uh oh, something went wrong"); }
  });
});


