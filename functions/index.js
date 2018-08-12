
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

//listen for following evetns and then trigger a push notification
exports.observeFollowing = functions.database.ref('/following/{uid}/{followingId}')
    .onCreate((snapshot, context) => {

    const original = snapshot.val();

    var uid = context.params.uid
    var followingId = context.params.followingId
    console.log('User: ', uid, 'is following ', followingId);

    return admin.database().ref('/users/' + followingId).once('value', snapshot => {

      var userWeAreFollowing = snapshot.val()

      return admin.database().ref('/users/' + uid).once('value', snapshot => {

        var userDoingTheFollowing = snapshot.val()

        var message = {
          notification: {
        	    title: "You now have a new follower",
        	    body: userDoingTheFollowing.username + ' '+'is now following you',
              sound: 'default'
        	  },

            data: {
              followerId: uid
            }
        }

        admin.messaging().sendToDevice(userWeAreFollowing.fcmToken ,message)
      	.then((response) => {
      	    // Response is a message ID string.
      	    console.log('Successfully sent message:', response);
      	    return response
      	  })
      	  .catch((error) => {
      	    console.log('Error sending message:', error);
      	    throw new Error("Error sending message");
      	  });
      })
    })

  })

// exports.sendPushNotifications = functions.https.onRequest((req, res) => {
// 	res.send("Attempting to send push notifications");
// 	console.log("LOGGER -- Trying to send push message");
//
//
//   var uid = 'o2lXgtNc9oT35R03UBuZJxaTusH2'
//
//   admin.database().ref('/users/' + uid).once('value', snapshot => {
//       var user = snapshot.val()
//
//       console.log("Users username:"+ user.username + "User fcmToken:"+ user.fcmToken)
//
//       var message = {
//         notification: {
//       	    title: "You have a new follower",
//       	    body: "body will show up HERE"
//       	  },
//       }
//
//       admin.messaging().sendToDevice(user.fcmToken,message)
//     	.then((response) => {
//     	    // Response is a message ID string.
//     	    console.log('Successfully sent message:', response);
//     	    return response
//     	  })
//     	  .catch((error) => {
//     	    console.log('Error sending message:', error);
//     	    throw new Error("Error sending message");
//     	  });
//
//
//   })
//
// 	// This registration token comes from the client FCM SDKs.
// 	// var fcmToken = 'e2BnCmdKIfw:APA91bGAHtNqJGEnR97LaWiVPU3UIqp37eqt0qEvEef4S-YmoaugMBBGTYhLsG1IuDibPt3ThJJ-8k-Nt4rLAhrNrXbgOL81bUgtRvIWah_0lwo0iGouQC1yVWamWu71OKY7jYwEBG82LYhGyW3XyASd9zO99d5CHA';
//   //
// 	// // See documentation on defining a message payload.
// 	// var message = {
// 	//   notification: {
// 	//     title: "Push notification title HERE",
// 	//     body: "body HERE"
// 	//   },
// 	//   data: {
// 	//     score: '850',
// 	//     time: '2:45'
// 	//   }
// 	// };
//   //
// 	// // Send a message to the device corresponding to the provided
// 	// // registration token.
// 	// return admin.messaging().sendToDevice(fcmToken,message)
// 	// .then((response) => {
// 	//     // Response is a message ID string.
// 	//     console.log('Successfully sent message:', response);
// 	//     return response
// 	//   })
// 	//   .catch((error) => {
// 	//     console.log('Error sending message:', error);
// 	//     throw new Error("Error sending message");
// 	//   });
//
// });
