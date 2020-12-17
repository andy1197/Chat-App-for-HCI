pod# Human Emotional Prediction Chat
## Description
A messenger application that interprets common facial expressions as emotional responses. Designed for research purposes only.

## Technologies
* Swift
* iOS
* Apple's ARKit
* Firebase
* JSQMessages

## Predicting Emotions
Emotions are predicted directly by facial expressions. The expressions are detected using Apple's ARKit, specifically [ARFaceAnchor](./https://developer.apple.com/documentation/arkit/arfaceanchor/blendshapelocation) which uses coefficents to detect microexpressions of the face. The app currently handles "Happy" (via SmileExpression), "Sad" (via FrownExpression), "Surprise" (via SurpriseExpression), "Angry" (via AngerExpression). Below is a reference to the universal facial expressions humans have.
![Common Facial Expressions](https://i.imgur.com/dtyIYQ0.png)

## Setting Up Pods
This application uses [CocoaPods](./https://cocoapods.org/about) to manage dependencies. There is a podfile located in the **backup_pod** that must be used to aquire all needed dependencies. The dependencies built are primarily for using Firebase. Here is a method to set up Pods:
* On terminal, move to the chat_app_for_hci directory
* While Xcode is closed, initialize pods for the project by doing:
```$ pod init && pod install```
* This would've created a Podfile visible directly in chat_app_for_hci. Remove this Podfile and replace it with the one located in the backup_pod folder
* Now on terminal again run:
```$ pod install```
Once this is finished, open the **Chat App For HCI.xcworkspace** 

## Using the App
### Sign In
You can either sign in with an existing account or by creating a unique credential.
Since this app is for research purposes, there is a default user defined as **Tester** with the login credentials **tester@mail.com**, password: **123456**, any other user is considered a **Subject**. There is also a **subject@mail.com** with password **123456** for testing purposes. Each user is given a unique id when created, by default Tester is given the ID: lqizrjTo60Q3vTZlo16W0wldNA63.
* To create a new user, simply type out the credentials in the username and password slots and then press sign up. The username suffix "@mail.com" and password "123456" has been the general template.
* To login, fill the slots with valid credentials and click login
* Handling users (such as deleting ones not needed anymore) can be done via the Firebase database (more on Firebase next section)
### Session Creation
Once logged in, the interface will request from you if you want to continue a pre-existing session by clicking **Continue Session**. A new session can be created by clicking **New Session**. Each time a new session is created, a unique ID is given to the session and the data corresponding to the session can be found on the Firebase database. It is best for the Tester to only create the new sessions during trial runs.
### Chatting
**Note: ONLY one Tester and Subject should be in a session at a time** 
* Emotions are only read from the Subject side.
* A subject will know if their emotion was detected via vibration of phone, they and the Tester will see this expression on the Subject's avatar only after the subject has sent a message.
* Avatars Happy, Sad, Angry, Surprised: ![Happy](./emotes/smileMS.png)
![Sad](./emotes/sadMS.png)
![Angry](./emotes/angryMS.png)
![Surprise](./emotes/stunnedMS.png)
* There is also a reset expression button in the case the Subject feels that they weren't expressing emotion even though the app detected something. The "wrong" emotion is recorded alongside the actual emotion that was set with the message the Subject sent.

## Using Firebase
Firebase maintains a database that contains all json data of text-messages and expressions sent and recieved. Data is segmented between "Contacts" and "Sessions". In Contacts, you can find all the subject users created. In Sessions, you can find a list of conversation sessions marked with unique IDs. Below is an example of what it looks like:
![Firebase Database](https://i.imgur.com/f29I1os.png)
The current database is registered and is called **chathci-2fe3a**, to gain permissions to access and use this database please contact the Author (located below). To create a new database, one must register with the app's bundle ID and create/place a "GoogleService-Info.plist" file created via Firebase. More information about registration can be found [here](https://firebase.google.com/docs/ios/setup).

## Author
Sudeep Raj - thesudeepraj@gmail.com
