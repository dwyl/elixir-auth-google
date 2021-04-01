# Creating a Google Application for OAuth2 Authentication

This is a step-by-step guide
for creating a Google App from scratch
so that you can obtain the API keys
to add Google OAuth2 Authentication
to your Elixir App
and save the credentials to environment variables.<br />
Our guide follows the _official_ docs:
https://developers.google.com/identity/sign-in/web/server-side-flow <br />
We've added detail and screenshots to the steps
because some people have found the official Google API docs confusing. <br />
_This_ guide is checked periodically by the @dwyl team/community,
but Google are known to occasionally change their UI/Workflow,
so if anything has changed, or there are extra/fewer steps,
[please let us know!](https://github.com/dwyl/elixir-auth-google/issues)

## 1. Create a New Project

In your preferred web browser,
visit:
https://console.developers.google.com
and ensure you are authenticated with your Google Account
so you can see your "API & Services Dashboard":

<img width="972" alt="elixir-auth-google-create-new-app" src="https://user-images.githubusercontent.com/194400/69722359-c7f29680-110e-11ea-90ae-da11ba42cc4a.png">

If you don't already have a Google APIs project for your Elixir App,
click the **CREATE** button on the dashboard.


## 2. Define the Details for your New Project (App)

Enter the details for your App's **Project name**
and where appropriate input any additional/relevant info:

<img width="972" alt="elixir-auth-google-app-details" src="https://user-images.githubusercontent.com/194400/69722801-ead17a80-110f-11ea-9bc9-d145b29baac6.png">

Click the **CREATE** button to create your project.


## 3. OAuth Consent Screen

After creating the New Project,
the UI will return to the APIs dashboard
and the name of your app will appear in the top menu.

Click the **OAuth Consent Screen** from the left side menu:

<img width="959" alt="elixir-auth-google-consent-screen" src="https://user-images.githubusercontent.com/194400/69727668-e78fbc00-111a-11ea-8b39-124a4b045b02.png">

Make the Application **`Public`** (_the default option_) and
input the same name as you used for your application in step 1.
Upload an image if you have one (_e.g: the icon/logo for your app_):

<img width="1226" alt="OAuth-consent-screen-1of2" src="https://user-images.githubusercontent.com/194400/69727443-76500900-111a-11ea-9425-bff972afe565.png">

Leave the "**Scopes for Google APIs**" set to the default
**email**, **profile** and **openid**.

No other data is required at this point, so skip the rest.

Scroll down to the bottom and click "**Save**":
<img width="1277" alt="OAuth-consent-screen-2of2" src="https://user-images.githubusercontent.com/194400/69727445-76e89f80-111a-11ea-860d-fd41939dd10f.png">

This will take you to the API Credentials page.

## 4. Create Credentials

Click the **Create Credentials** button:
<img width="960" alt="Screenshot 2019-11-26 at 23 24 28" src="https://user-images.githubusercontent.com/194400/69725288-b2cd3600-1115-11ea-9601-04054cac6f5b.png">
That will popup a menu from which you will select **OAuth Client ID**.

You will see a form that allows you to specify
the details of your App for the credentials.

<img width="971" alt="Screenshot 2019-11-27 at 02 13 55" src="https://user-images.githubusercontent.com/194400/69728313-296d3200-111c-11ea-8da0-85c1ade89d8a.png">

+ Application Type: Web application
+ Name: Elixir Auth Server
+ Authorized JavaScript origins:
http://localhost:4000
(_the default for a Phoenix app on your local dev machine.
  you can add your "production" URL later._)
+ Authorized redirect URIs:  
http://localhost:4000/auth/google/callback
(_the endpoint to redirect to once authentication is successful.
  again, add your production URL once you have auth working on `localhost`_)

> Ensure you hit the enter key after pasting/typing
the URIs to ensure they are saved.
A common stumbling block is that URIs aren't saved. See:
https://stackoverflow.com/questions/24363041/redirect-uri-in-google-cloud-console-doesnt-save

Once you have input the relevant data click the **Create** button.

> This form/step can be confusing at first,
but essentially you can have multiple credentials
for the same project,
e.g: if you had a Native Android App
you would create a new set of credentials
to ensure a separation of concerns between
server and client implementations.
For now just create the server (Elixir) credentials.


## 5. Download the OAuth Client Credentials

After you click the **Create** button
in the **Create OAuth client ID** form (_step 4 above_),
you will be shown your OAuth client Credentials:

<img width="970" alt="elixir-auth-google-oauth-client-credentials" src="https://user-images.githubusercontent.com/194400/69730648-5cb1c000-1120-11ea-8ad4-0ef62cfb6a0a.png">

Download the credentials, e.g:

+ Client ID: 631770888008-6n0oruvsm16kbkqg6u76p5cv5kfkcekt.apps.googleusercontent.com
+ Client Secret: MHxv6-RGF5nheXnxh1b0LNDq

> ⚠️ Don't worry, these keys aren't valid.
We deleted them immediately after capturing the screenshot
to avoid any security issues.
Obviously treat your credentials
like you would the username+password for your bank account;
never share a **real** Client ID or secret on GitHub
or any other public/insecure forum!

You can also download the OAuth credentials as a json file:

<img width="821" alt="elixir-auth-google-json" src="https://user-images.githubusercontent.com/194400/69736916-57a63e00-112b-11ea-8b28-6f137f00106b.png">

Example:
```json
{
  "web": {
    "client_id": "631770888008-6n0oruvsm16kbkqg6u76p5cv5kfkcekt.apps.googleusercontent.com",
    "project_id": "elixir-auth-demo",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_secret": "MHxv6-RGF5nheXnxh1b0LNDq",
    "redirect_uris": [
      "http://localhost:4000/auth/google/callback"
    ],
    "javascript_origins": [
      "http://localhost:4000"
    ]
  }
}
```

> Again, for security reasons,
these credentials were
invalidated _immediately_ after downloading. <br />
But this is what the file looks like.


Return to step 3 of the
[README.md](https://github.com/dwyl/elixir-auth-google/blob/master/README.md)


<br />

# Note

When you ship your app to your Production environment,
you will need to re-visit steps 3 & 4
to update your app settings URL & callback
to reflect the URl where you are deploying your app e.g:

![add-heroku-app](https://user-images.githubusercontent.com/194400/70204921-32f92a00-171a-11ea-83b2-34e5eeea777b.png)

In our case
https://elixir-auth-google-demo.herokuapp.com
and
https://elixir-auth-google-demo.herokuapp.com/auth/google/callback
