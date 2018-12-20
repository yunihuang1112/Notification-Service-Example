var apn = require('apn');
 
var options = {
  token: {
    key: "my_key_name.p8",
    keyId: "my_key_id",
    teamId: "my_team_id"
  },
  production: false
//   production: true //AdHoc
};
 
let deviceToken = "my_device_token";

var apnProvider = new apn.Provider(options);
var note = new apn.Notification();

note.topic = "my_bundle_id";

note.badge = 0;
note.alert = {
				body: "Notification test"
};
note.sound = "default";
note.mutableContent = 1;
note.category = "noti_service_ex";
note.payload = {
    "media-url": "my_media_url" 
};

console.log(note);
apnProvider.send(note, deviceToken).then( (result) => {
    console.log(result);
	console.log(result["failed"][0]["response"]);
});









