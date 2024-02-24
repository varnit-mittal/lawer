
![Logo](https://github.com/varnit-mittal/lawer/blob/main/logo.jpg)


# Lawer

An android app that offers a dual-purpose resource for those facing legal challenges and law students seeking knowledge.  Gain insights from past cases, explore relevant laws, and find potential avenues for assistance with your unique situation. Enhance your legal understanding with this project. Explore real-world case studies to deepen your grasp of various legal scenarios. Discover crucial laws and how they shape different types of cases.

Flutter is used to create the [front-end](https://github.com/varnit-mittal/lawer/tree/main/flutter_first) of the application.

Django Rest-Framework is used to create an API which powers the application.


## Features

- An OTP login service is used so that there is no need for password management.
- An extensive file storage system is provided with the help of Firebase Storage for better management of your legal files. 
- With Gemini's assistance, a precedent-searching system is created that produces highly relatable results based on the user-provided case.
- Efficient law searching is used to provide relevant laws to the user based ont heir query. User can also provide multiple queries which are also handled efficiently using keyword searching.
- The app can also used by students who are currently pursuing law in order to get various case studies for different scenarios they proivde to the app.


## Tech Stack

**Client:** Flutter, Firebase

**Server:** Django, Django-REST, Firebase, Gemini 


## Environment Variables for Back-End

To run this project, you will need to add the following environment variables to your .env file

`GOOGLE_GEMINI_API_KEY` which is Gemini API key

`FIREBASE_SDK`which is your Firebase private key

`KANNON`which is an API to fetch documents from Central Government repository 

`ADMIN` the admin url to manage your backend


## API Reference

#### Get all items

```bash
  GET https://api.indiankanoon.org/doc/${id}
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `api_key` | `string` | **Required**. Your API key |

#### Fetches the necessary documents from Central Government Repository

```bash
  GET Gemini
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `api_key`      | `string` | **Required**.  Your API key |

#### Used to Serialize the query enetered by the user

## Backend endpoints

| URL| Use   | 
| :-------- | :------- | 
| `/<ADMIN>` | admin controller page |
| `/folder/` | to create  a new folder | 
| `/file/` | to get all the files and the folders and delete also |
| `/fileUpload/` | upload or update your file to your firebase storage |
| `/getfile/` | download the file |
| `/caseQuery/` | to enquire about your case |
| `/listQuery/` | in case your query is very sensitive |
| `/getLaws/` | to get the appropriate law according to your query |
| `/getDocument/` | to fetch the full document from Central Government Repository |

## Run Locally Back-End

Clone the project

```bash
  git clone https://github.com/varnit-mittal/lawer.git
```

Go to the project directory

```bash
  cd lawer
```

Install dependencies

```bash
  pip install -r requirements.txt
```

Start the server

```bash
  python manage.py runserver 
```


## Demo

Insert gif or link to demo


## Documentation

[Documentation](https://linktodocumentation)


## Feedback

If you have any feedback, please reach out to us at varnit03mittal@gmail.com


## Authors

- [@varnit-mittal](https://github.com/varnit-mittal)
- [@ap5967ap](https://github.com/ap5967ap)
- [@aryamanpathak2022](https://github.com/aryamanpathak2022)
- [@SiddharthVikram069](https://github.com/SiddharthVikram069)


## License

[MIT](https://github.com/varnit-mittal/lawer/blob/main/LICENSE)

