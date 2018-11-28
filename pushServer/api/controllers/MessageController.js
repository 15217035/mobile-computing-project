/**
 * MessageController
 *
 * @description :: Server-side logic for managing Messages
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */

module.exports = {

    show:function(req, res){
        print("hihi");
    },

    received: function (req, res) {

        
        var token1 = ""
        var message1 = ""

        var arr = { message: 'yu@gmail.com send you a message.',
        token: '364E9F4966BCD6E8C7189D238143AB28EA6B9C5BD146280C690EEEEDC5AF46ED' }

        // console.log(arr.token)
        
        console.log(req.body)
        console.log(req.body.message)

        console.log(req.body.token)

        if( req.method == "POST" ){

            message1 = req.body.message 
           token1 = req.body.token 
           
        }
        
        

        var apn = require('apn');

        // Set up apn with the APNs Auth Key
        var apnProvider = new apn.Provider({
            token: {
                key: 'AuthKey_Q5BYH559L8.p8', // Path to the key p8 file
                keyId: 'Q5BYH559L8', // The Key ID of the p8 file (available at https://developer.apple.com/account/ios/certificate/key)
                teamId: '2867B572P4', // The Team ID of your Apple Developer Account (available at https://developer.apple.com/account/#/membership/)
            },
            production: false // Set to true if sending a notification to a production iOS app
        });

        // Enter the device token from the Xcode console
        // var deviceToken = '364E9F4966BCD6E8C7189D238143AB28EA6B9C5BD146280C690EEEEDC5AF46ED';
        var deviceToken = token1
        // Prepare a new notification
        var notification = new apn.Notification();

        // Specify your iOS app's Bundle ID (accessible within the project editor)
        notification.topic = 'hk.edu.hkbu.comp.LS08Push';

        // Set expiration to 1 hour from now (in case device is offline)
        notification.expiry = Math.floor(Date.now() / 1000) + 3600;

        // Set app badge indicator
        notification.badge = 1;

        // Play ping.aiff sound when the notification is received
        notification.sound = 'ping.aiff';

        // Display the following message (the actual notification text, supports emoji)
        notification.alert = message1;

        // Send any extra payload data with the notification which will be accessible to your app in didReceiveRemoteNotification
        notification.payload = { id: 123 };

        // Actually send the notification
        apnProvider.send(notification, deviceToken).then(function (result) {
            // Check the result for any failed devices
            console.log(result);
        });

        return res.json({});


    },

    interface: function(req, res) {


        return res.view('interface');
    }

};

