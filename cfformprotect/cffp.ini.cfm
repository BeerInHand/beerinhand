<cfsilent>
#Please read Installation.html for a description of these values and how to customize this for your needs

[CFFormProtect]
#which tests to run
mouseMovement=1
usedKeyboard=1
timedFormSubmission=1
hiddenFormField=1
akismet=0
tooManyUrls=1
teststrings=1
projectHoneyPot=0

#settings for individual tests
timedFormMinSeconds=5
timedFormMaxSeconds=3600
encryptionKey=JacobMuns0n
akismetAPIKey=
akismetBlogURL=
akismetFormNameField=
akismetFormEmailField=
akismetFormURLField=
akismetFormBodyField=
tooManyUrlsMaxUrls=6
spamstrings='free music,download music,music downloads,viagra,phentermine,viagra,tramadol,ultram,prescription soma,cheap soma,cialis,levitra,weight loss,buy cheap,Christian Louboutin'
projectHoneyPotAPIKey=

#the points each test costs for failure
mouseMovementPoints=1
usedKeyboardPoints=1
timedFormPoints=2
hiddenFieldPoints=3
akismetPoints=3
tooManyUrlsPoints=3
spamStringPoints=2
projectHoneyPotPoints=3

#how many points will flag the form submission as spam
failureLimit=3

#email settings
emailFailedTests=1
emailServer=
emailUserName=
emailPassword=
emailFromAddress=donotrespond@beerinhand.com
emailToAddress=spam@beerinhand.com
emailSubject=So this happened...

#logging
logFailedTests=1
logFile=
</cfsilent>