# Creating a Google Application for OAuth2 Authentication

This is a step-by-step guide for creating a Google App from scratch so that you can obtain the API keys to add Google OAuth2 Authentication to your Elixir App and save the credentials to environment variables.

Our guide follows the _official_ docs:
<https://developers.google.com/identity/gsi/web/guides/get-google-api-clientid>

We've added detail and screenshots to the steps because some people have found the official Google API docs confusing.

_This_ guide is checked periodically by the @dwyl team/community, but Google are known to occasionally change their UI/Workflow, so if anything has changed, or there are extra/fewer steps, [please let us know!](https://github.com/dwyl/elixir-auth-google/issues)

## 1. Create a New Project

In your preferred web browser, visit:

<https://console.developers.google.com/apis>

and ensure you are authenticated with your Google Account so you can see your "API & Services Dashboard":

<img width="972" alt="elixir-auth-google-create-new-app" src="https://user-images.githubusercontent.com/194400/69722359-c7f29680-110e-11ea-90ae-da11ba42cc4a.png">

If you don't already have a Google APIs project for your Elixir App,
click the **CREATE** button on the dashboard.

## 2. Define the Details for your New Project (App)

![new project](images/Screenshot%202022-10-27%20at%2011.24.10.png)

![new project saved](images/Screenshot%202022-10-27%20at%2014.04.54.png)

Click the **CREATE** button to create your project.

## 3. OAuth Consent Screen

Click on "Google Cloud", then "Dashboard", then
**OAuth Consent Screen** from the left side menu:

![Oauth consent](images/Screenshot%202022-10-27%20at%2014.18.31.png)

Set "external":

![external](images/Screenshot%202022-10-27%20at%2014.11.44.png)

and enter the details for your App's **Project name** and where appropriate input any additional/relevant info: App name, the User support email and Developper contanct information.

## 4. Create Credentials

Click on "Google Cloud", then "Dashboard", then "APIs and services" then "Credentials", then "+ CREATE CREDENTIALS", then "OAuth client ID".

![credentials](images/Screenshot%202022-10-27%20at%2014.10.24.png)

Click the **Create Credentials** button:

- Application Type: **Web application**
- Name: "_the one you want_"
- Authorized redirect URIs: **the same as the one yo udefined in your router**:
  http://localhost:4000/auth/google/callback
  (_the endpoint to redirect to once authentication is successful.
  :exclamation: add your production URL once you have auth working on `localhost`_)

Then save your credentials in `env. file:

```env
# .env
export GOOGLE_CLIENT_ID="935113971xxx.apps.googleusercontent.com"
export GOOGLE_CLIENT_SECRET="GOCSPX-5jxxx"
```

> **Note**: the "client-id" is acccessible but not the secret. In case you missed it, you can always generate another one with "RESET SECRET"

![reset secret](images/Screenshot%202022-10-27%20at%2018.58.15.png)

:red_circle: Authorized JavaScript origins: **with this library, you don't use Google's SDK so you don't need this**.

> **Note**: if you want ot use **One tap**, then you need to pass an authorized url: in **DEV** mode, it is <http://localhost:4000> **AND** <http://localhost>.

Then, don't forget to:

![save](images/Screenshot%202022-10-27%20at%2018.45.46.png)

> A common stumbling block is that URIs aren't saved. See:
> https://stackoverflow.com/questions/24363041/redirect-uri-in-google-cloud-console-doesnt-save

Once you have input the relevant data click the **Create** button.

> This form/step can be confusing at first, but essentially you can have multiple credentials for the same project, e.g: if you had a Native Android App you would create a new set of credentials to ensure a separation of concerns between server and client implementations.
> For now just create the server (Elixir) credentials.

## Update for production mode

When you ship your app to your Production environment,
you will need to re-visit step 2 and 4 to update your app settings URL & callback to reflect the URl where you are deploying your app e.g:

![add-heroku-app](https://user-images.githubusercontent.com/194400/70204921-32f92a00-171a-11ea-83b2-34e5eeea777b.png)

In our case:

<https://elixir-auth-google-demo.herokuapp.com>

and:

<https://elixir-auth-google-demo.herokuapp.com/auth/google/callback>
