# News App

Sign In and watch news online or offline and search news using headlines.

## Getting Started

Firebase email auth and google signin is used for user login and registration.
After successful login News page will be opened, network connectivity get checked using connecivity_plus package and if network is connected then news detail will get fetched using news api and stored in local storage using flutter_secure_storage package, if newtork is not connected then data is fetched from local storage.
You can search news using headings text, news details contain updated time, author, title, news description and image.

## Dependencies used:-

 firebase_core , 
  firebase_auth, 
  google_sign_in,
  pinput, 
  font_awesome_flutter, 
  connectivity_plus, 
  flutter_secure_storage, 
  http, 
  jiffy, 
