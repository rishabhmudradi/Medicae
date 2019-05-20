## Medicae

# Developers:
- Rishabh Mudradi
- Shashank Venkatramani
- Pranav Eranki
- Aryan Kaul

## Inspiration
In September 2013, 44 children in Paraguay were admitted to hospital with breathing difficulties. It turned out the children had all been given a locally made cough medicine. Investigators went to the factory and found import records for the dextromethorphan it contained. When they checked the World Health Organization’s database of substandard and falsified medical products, they found that this came from the same batch that had caused the deaths in Pakistan. In this situation, a fake drugs detector and authenticator would have helped extensively to save lives, money, and time.

## What it does
Our app identifies fake drugs through QR codes and authenticates that they are both legitimate medicines, and that the medicine containers have not been used multiple times before - this ensures that the containers are filled with legitimate medicine, used once, then disposed of, as to prevent drug fraud.

Our goal is to reduce the number of fake medicines on the market which could potentially harm people. In addition, we wanted to go above and beyond, addressing another immense issue and detecting melanoma in its early stages to save lives. 

**Fake medicine detector** - The detector checks to make sure the unique QR code has not been used previously. If it has, then it is a repackaged fake medicine.

**Medicine Identification** - Through the reading of the QR code, the app returns what the medicine is, dosage, and some basic info.

**Melanoma detector** -   We used a coreml model and trained it using 5,000 images to perfect the model.

## How we built it

**Backend**
To create medicae we used firebase as our backend source to store QR codes and run authentication/identification. We also used python for the generation and identification of QR codes.

We have a flask app coded, but not implemented in our final model. 
Our CNN model uses a class architecture to define a keras sequential model and then create a complex CNN model, complete with custom fitting, predicting, and model saving helper methods.
We have helper files for downloading, prepping, organizing, and labeling images. Then the images are scaled to usable dimensions of 64 x 64

**Frontend**
UI/Design - We wanted medicae to be accessible to all age groups, so having a unique UI was important. We had multiple drawings of the app and used Sketch to design and create them.
After incorporating our UI and backend system we used Xcode and Swift to create the application. We had many view controllers for specific purposes.
After creating the app, we had our team navigate and extensively test the application, before being satisfied with our project just in time for submission.

## Challenges we ran into
We had issues converting our keras model to a coreml model.
We had various issues with QR code scanning.
Our database was also quite finicky for the different data we had.


## Accomplishments that we're proud of

** Nearly 2000 lines of code!! **

**Swift App** - Finished a full XCode application, used AVFoundation for camera, used AVFoundation for QR Code readers, used a collection view for a stunning UI, and extensive backend for uploading and downloading data

**Python Backend** - Our initial machine learning model was almost 1000 lines of code using Keras and ISIC data. However, converting it to a CoreML model did not work, due to the conflict with the h5 and JSON files. We decided to change to using createML to make a CoreML model that would more fluidly address our needs.

**Firebase** - Created a data model with arrays and objects to manage different medicine types, with their corresponding scanning status, dosage stats, and description

## What we learned
- Keras
- iOS dev
- QR code usage
- Medical drug information
- CoreML

## App Render
<img width="500" heigth="200" alt="appview" src="https://user-images.githubusercontent.com/22282701/57993515-2529d300-7a6e-11e9-8b2c-700d7fd9f8fe.jpg">

## Database
![](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/000/795/290/datas/gallery.jpg)

## QR codes
![](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/000/795/288/datas/gallery.jpg)

