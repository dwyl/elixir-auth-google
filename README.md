<div align="center">

# `elixir-auth-google`

The _easiest_ way to add Google OAuth authentication to your Elixir Apps.

![sign-in-with-google-buttons](https://user-images.githubusercontent.com/194400/69637172-07a67900-1050-11ea-9e25-2b9e84a49d91.png)

[![Build Status](https://github.com/dwyl/elixir-auth-google/workflows/Elixir%20CI/badge.svg?style=flat-square)](https://github.com/dwyl/elixir-auth-google)
<!-- [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-brightgreen.svg?style=flat-square)](https://GitHub.com/TutorialsAndroid/GButton) -->

</div>

# _Why_? 🤷

We needed a **_much_ simpler**
and **_extensively_ documented** way
to add "_**Sign-in** with **Google**_"
capability to our Elixir App(s). <br />

# _What_? 💭

An Elixir package that seamlessly handles
Google OAuth2 Authentication/Authorization.

> We needed a lightweight solution
that only does _one_ thing
and is easy for complete beginners to understand/use.
There were already _several_ available options
for adding Google Auth to apps on on Hex.pm:
[hex.pm/packages?search=google](https://hex.pm/packages?search=google)
that all added _far_ too implementation steps (complexity)
and had incomplete documentation and testing.
e.g:
[github.com/googleapis/elixir-google-api](https://github.com/googleapis/elixir-google-api)
which is a
["_generated_"](https://github.com/googleapis/elixir-google-api/blob/master/scripts/generate_client.sh)
client and is considered "experimental".
We have drawn inspiration from several sources
including packages in other programming languages to build this package.
This package is _much_ simpler
than anything else
and has both step-by-step instructions
and an _complete working example_ App
including how to encrypt tokens for secure storage
to help you ship your app _fast_.


# _Who_? 👥

This module is for people building apps using Elixir/Phoenix
who want to ship the "Sign-in with Google" feature _faster_
and more maintainably.

It's targetted at _complete_ beginners
with no prior experience/knowledge
of auth "schemes" or "strategies".
Just follow the detailed instructions
and you'll be up-and running in 5 minutes.


# How? ✅

You can use `elixir_auth_google` in your Elixir App in 4 easy steps:

## 1. Add the hex package to `deps` 📦

Open your project's **`mix.exs`** file
and locate the **`deps`** (dependencies) section.
Add a line for **`:elixir_auth_google`** in the **`deps`** list:

```elixir
def deps do
  [
    {:elixir_auth_google, "~> 1.0.0"}
  ]
end
```

Once you have added the line to your **`mix.exs`**,
remember to run the **`mix deps.get`** command
in your terminal
to _download_ the dependencies.


## 2. Create a Google Application 🆕

Visit
[console.developers.google.com](https://console.developers.google.com/projectselector2/apis/dashboard)
and


http://localhost:4000

http://localhost:4000/auth/google/callback


631770888008-6n0oruvsm16kbkqg6u76p5cv5kfkcekt.apps.googleusercontent.com

MHxv6-RGF5nheXnxh1b0LNDq

> Don't worry, these keys aren't valid.
We deleted them immediately after capturing the screenshot
to avoid any security issues.


2. Create a Google application and generate OAuth credentials for the application

3. Set up `:elixir_auth_google` configuration values
`google_client_id`, `google_scope` ("profile" by default) and `google_redirect_uri` (the same as the one defined in the google application)

for example in `config.exs`:
```elixir
config :elixir_auth_google,
  google_client_id: <YOUR-CLIENT-ID-HERE>,
  google_scope: "profile",
  google_redirect_uri: <REDIRECT_URI>,
```

- Create a new endpoint matching the `google_redirect_uri`.
On this endpoint you can exchange the google code
for the user's token
and then get the user profile:

```eixir
  def index(conn, %{"code" => code}) do
    token = ElixirAuthGoogle.get_token(code)
    profile = ElixirAuthGoogle.get_user_profile(token["access_token"])
    render(conn, "index.html", profile: profile)
  en
```



If you are using the the **`elixir_auth_google`** package
in a Phoenix application (_the most popular use case_),


### Generating Phoenix Session Key (`SECRET_KEY_BASE`) and Encryption Keys

To generate a cryptographically secure session key,
open your terminal, run the command **`mix phx.gen.secret`**
and paste the resulting string



<br /><br />

## Notes 💡

+ Official Docs for Google Identity Platform:
https://developers.google.com/identity/choose-auth
  + Web specific sample code (JS):
  https://developers.google.com/identity/sign-in/web
+ Google Sign-In for server-side apps:
https://developers.google.com/identity/sign-in/web/server-side-flow
+ Using OAuth 2.0 for Web Server Applications:
https://developers.google.com/identity/protocols/OAuth2WebServer
+ Google Auth Branding Guidelines:
https://developers.google.com/identity/branding-guidelines <br />
Only two colors are permitted for the button:
**white** `#FFFFFF` and **blue** `#4285F4`

![two-colors-of-google-auth-button](https://user-images.githubusercontent.com/194400/69634312-d9be3600-1049-11ea-9354-cdaa53f5c42b.png)


### Fun Facts 📈📊

Unlike other "social media" companies,
Google/Alphabet does not report it's
_Monthly_ Active Users (MAUs)
or _Daily_ Active Users (DAUs)
however they do release stats in drips
in their Google IO or YouTube events.
The following is a quick list of facts
that make adding Google Auth to your App
a compelling business case:

+ As of May 2019, there are over
[2.5 Billion](https://www.theverge.com/2019/5/7/18528297/google-io-2019-android-devices-play-store-total-number-statistic-keynote)
_active_ Android devices;
[87%](https://www.idc.com/promo/smartphone-market-share/os) global market share.
All these people have Google Accounts in order to use Google services.
+ YouTube has
[2 billion](https://www.businessofapps.com/data/youtube-statistics/)
monthly active YouTube users (_signed in with a Google Account_).
+ Gmail has
[1.5 Billion](https://www.thenewsminute.com/article/googles-gmail-turns-15-now-has-over-15-billion-monthly-active-users-99275)
monthly active users a
[27% share](https://seotribunal.com/blog/google-stats-and-facts)
 of the global email client market.
+ [65%](https://techjury.net/stats-about/gmail-statistics)
of Small and Medium sized businesses use Google Apps for business.
+ [90%+](https://techjury.net/stats-about/gmail-statistics)
of startups use Gmail. This is a good _proxy_ for "early adopters".
+ [68%](https://eu.azcentral.com/story/opinion/op-ed/joannaallhands/2017/10/09/google-classroom-changing-teachers-students-education/708246001/)
of schools in the US use Google Classroom and related G-suite products. <br />
So the _next_ generation of internet/app users have Google accounts.
+ Google has
[90.46%](https://seotribunal.com/blog/google-stats-and-facts/)
of the search engine market share worldwide. 95.4% on Mobile.

Of the 4.5 billion internet users (58% of the world population),
around 3.2 billion (72%) have a Google account.
90%+ of tech "early adopters" use Google Apps
which means that adding Google OAuth Sign-in
is the _logical_ choice for _most_ Apps.

### Privacy Concerns? 🔐

A _common misconception_ is that adding Google Auth Sign-in
sends a user's application data to Google.
This is **`false`** and App developers have 100% control
over what data is sent to (stored by) Google.
An App can use Google Auth to _authenticate_ a person
(_identify them and get read-only access
  to their personal details like **first name** and **email address**_)
without sending any data to Google.
Yes, it will mean that Google "knows" that the person is _using_ your App,
but it will not give Google any insight into _how_ they are using it
or what types of data they are storing in the App. Privacy is maintained.
So if you use the @dwyl app to plan your wedding or next holiday,
Google will not have _any_ of that data
and will not serve any annoying ads based on your project/plans.
