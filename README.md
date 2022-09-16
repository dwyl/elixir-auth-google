<div align="center">

# `elixir-auth-google`

The _easiest_ way to add Google OAuth authentication to your Elixir Apps.

![sign-in-with-google-buttons](https://user-images.githubusercontent.com/194400/69637172-07a67900-1050-11ea-9e25-2b9e84a49d91.png)

![Build Status](https://img.shields.io/travis/com/dwyl/elixir-auth-google/master?color=bright-green&style=flat-square)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/elixir-auth-google/master.svg?style=flat-square)](http://codecov.io/github/dwyl/elixir-auth-google?branch=main)
[![Hex.pm](https://img.shields.io/hexpm/v/elixir_auth_google?color=brightgreen&style=flat-square)](https://hex.pm/packages/elixir_auth_google)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/elixir-auth-google/issues)
[![HitCount](http://hits.dwyl.com/dwyl/elixir-auth-google.svg)](http://hits.dwyl.com/dwyl/elixir-auth-google)
<!-- [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-brightgreen.svg?style=flat-square)](https://GitHub.com/TutorialsAndroid/GButton) -->

</div>

# _Why_? 🤷

We needed a **_much_ simpler**
and **_extensively_ documented** way
to add "_**Sign-in** with **Google**_"
capability to our Elixir App(s). <br />

# _What_? 💭

An Elixir package that seamlessly handles
Google OAuth2 Authentication/Authorization
in as few steps as possible. <br />
Following best practices for security & privacy
and avoiding complexity
by having sensible defaults for all settings.


> We built a lightweight solution
that only does _one_ thing
and is easy for complete beginners to understand/use. <br />
There were already _several_ available options
for adding Google Auth to apps on
[hex.pm/packages?search=google](https://hex.pm/packages?search=google) <br />
that all added _far_ too many implementation steps (complexity)
and had incomplete docs (**`@doc false`**) and tests. <br />
e.g:
[github.com/googleapis/elixir-google-api](https://github.com/googleapis/elixir-google-api)
which is a
["_generated_"](https://github.com/googleapis/elixir-google-api/blob/master/scripts/generate_client.sh)
client and is considered "experimental". <br />
We have drawn inspiration from several sources
including code from other programming languages to build this package.
This result is _much_ simpler
than anything else
and has both step-by-step instructions
and a _complete working example_ App
including how to encrypt tokens for secure storage
to help you ship your app _fast_.


# _Who_? 👥

This module is for people building apps using Elixir/Phoenix
who want to ship the "Sign-in with Google" feature _faster_
and more maintainably.

It's targetted at _complete_ beginners
with no prior experience/knowledge
of auth "schemes" or "strategies". <br />
Just follow the detailed instructions
and you'll be up-and running in 5 minutes.


# _How_? ✅

You can add Google Authentication to your Elixir App
using **`elixir_auth_google`** <br />
in under **5 minutes**
by following these **5 _easy_ steps**:

## 1. Add the hex package to `deps` 📦

Open your project's **`mix.exs`** file
and locate the **`deps`** (dependencies) section. <br />
Add a line for **`:elixir_auth_google`** in the **`deps`** list:

```elixir
def deps do
  [
    {:elixir_auth_google, "~> 1.6.3"}
  ]
end
```

Once you have added the line to your **`mix.exs`**,
remember to run the **`mix deps.get`** command
in your terminal
to _download_ the dependencies.


## 2. Create Google APIs Application OAuth2 Credentials 🆕

Create a Google Application if you don't already have one,
generate the OAuth2 Credentials for the application
and save the credentials as environment variables
accessible by your app, or put them in your config file.

> **Note**: There are a few steps for creating a set of Google APIs credentials,
so if you don't already have a Google App,
we created the following step-by-step guide
to make it quick and _relatively_ painless:
[create-google-app-guide.md](https://github.com/dwyl/elixir-auth-google/blob/master/create-google-app-guide.md) <br />
Don't be intimidated by all the buzz-words;
it's quite straightforward.
And if you get stuck, ask for
[help!](https://github.com/dwyl/elixir-auth-google/issues)


## 3. Setup CLIENT_ID and CLIENT_SECRET in your project

You may either add those keys as environment variables or put them in the config:

```
export GOOGLE_CLIENT_ID=631770888008-6n0oruvsm16kbkqg6u76p5cv5kfkcekt.apps.googleusercontent.com
export GOOGLE_CLIENT_SECRET=MHxv6-RGF5nheXnxh1b0LNDq
```
Or add the following in the config file:

```elixir
config :elixir_auth_google,
  client_id: "631770888008-6n0oruvsm16kbkqg6u76p5cv5kfkcekt.apps.googleusercontent.com",
  client_secret: "MHxv6-RGF5nheXnxh1b0LNDq"

```
> ⚠️ Don't worry, these keys aren't valid.
They are just here for illustration purposes.


## 4. Create a `GoogleAuthController` in your Project 📝

Create a new file called
[`lib/app_web/controllers/google_auth_controller.ex`](https://github.com/dwyl/elixir-auth-google-demo/blob/master/lib/app_web/controllers/google_auth_controller.ex)
and add the following code:

```elixir
defmodule AppWeb.GoogleAuthController do
  use AppWeb, :controller

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, token} = ElixirAuthGoogle.get_token(code, conn)
    {:ok, profile} = ElixirAuthGoogle.get_user_profile(token.access_token)
    conn
    |> put_view(AppWeb.PageView)
    |> render(:welcome, profile: profile)
  end
end
```
This code does 3 things:
+ Create a one-time auth `token` based on the response `code` sent by Google
after the person authenticates.
+ Request the person's profile data from Google based on the `access_token`
+ Render a `:welcome` view displaying some profile data
to confirm that login with Google was successful.


## 5. Create the `/auth/google/callback` Endpoint 📍

Open your **`router.ex`** file
and locate the section that looks like `scope "/", AppWeb do`

Add the following line:

```elixir
get "/auth/google/callback", GoogleAuthController, :index
```

Sample: [lib/app_web/router.ex#L20](https://github.com/dwyl/elixir-auth-google-demo/blob/4bb616dd134f498b84f079104c0f3345769517c4/lib/app_web/router.ex#L20)

### Different callback url?

You can specify the env var

```
export GOOGLE_CALLBACK_PATH=/myauth/google_callback
```

or add it in the configuration

Or add the following in the config file:

```elixir
config :elixir_auth_google,
  # ...
  callback_path: "/myauth/google_callback"
```

## 6. Add the "Login with Google" Button to your Template ✨

In order to display the "Sign-in with Google" button in the UI,
we need to _generate_ the URL for the button in the relevant controller,
and pass it to the template.

Open the `lib/app_web/controllers/page_controller.ex` file
and update the `index` function:

From:
```elixir
def index(conn, _params) do
  render(conn, "index.html")
end
```

To:
```elixir
def index(conn, _params) do
  oauth_google_url = ElixirAuthGoogle.generate_oauth_url(conn)
  render(conn, "index.html",[oauth_google_url: oauth_google_url])
end
```

### 6.1 Update the `page/index.html.eex` Template

Open the `/lib/app_web/templates/page/index.html.eex` file
and type the following code:

```html
<section class="phx-hero">
  <h1>Welcome to Awesome App!</h1>
  <p>To get started, login to your Google Account: <p>
  <a href={@oauth_google_url}>
    <img src="https://i.imgur.com/Kagbzkq.png" alt="Sign in with Google" />
  </a>
</section>
```

# _Done_! 🚀

The home page of the app now has a big "Sign in with Google" button:

![sign-in-button](https://user-images.githubusercontent.com/194400/70202961-3c32c880-1713-11ea-9737-9121030ace06.png)

When the person clicks the button,
and authenticates with their Google Account,
they will be returned to your App
where you can display a "login success" message:

![welcome](https://user-images.githubusercontent.com/194400/70201692-494db880-170f-11ea-9776-0ffd1fdf5a72.png)


### _Optional_: Scopes

Most of the time you will only want/need
the person's email address and profile data
when authenticating with your App.
In the cases where you need more specific access
to a Google service, you will need to specify the exact scopes.
See:
https://developers.google.com/identity/protocols/oauth2/scopes

Once you know the scope(s) your App needs access to,
simply define them using an environment variable, e.g:

```
GOOGLE_SCOPE=email contacts photoslibrary
```

***or*** you can set them as a config variable if you prefer:

```
config :elixir_auth_google,
  :google_scope: "email contacts photoslibrary"
```

With that configured, your App will gain access to the requested services
once the person authenticates/authorizes.

<br /> <br />


## _Optimised_ SVG+CSS Button

In **step 6.1** above, we suggest using an `<img>`
for the `Sign in with GitHub` button.

But even though this image appears small **`389 × 93 px`**
https://i.imgur.com/Kagbzkq.png it is "only" **`8kb`**:

![google-button-8kb](https://user-images.githubusercontent.com/194400/73607428-cd0c1000-45ad-11ea-8639-ffc3e9a0e0a2.png)

We could spend some time in a graphics editor optimising the image,
but we _know_ we can do better by using our `CSS` skills! 💡

> **Note**: This is the _official_ button provided by Google:
[developers.google.com/identity/images/signin-assets.zip](developers.google.com/identity/images/signin-assets.zip) <br />
So if there was any optimisation they could squeeze out of it,
they probably would have done it before publishing the zip!

The following code re-creates the `<img>`
using the GitHub logo **`SVG`**
and `CSS` for layout/style:

```html
<div style="display:flex; flex-direction:column; width:368px; margin-left:133px;">
  <link href="https://fonts.googleapis.com/css?family=Roboto&display=swap">

  <a href="<%= @oauth_google_url %>"
    style="display:inline-flex; align-items:center; min-height:50px;
      background-color:#4285F4; font-family:'Roboto',sans-serif;
      font-size:28px; color:white; text-decoration:none;
      margin-top: 12px">
      <div style="background-color: white; margin:2px; padding-top:18px; padding-bottom:6px; min-height:59px; width:72px">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 533.5 544.3"
        width="52px" height="35" style="display:inline-flex; align-items:center;" >
        <path d="M533.5 278.4c0-18.5-1.5-37.1-4.7-55.3H272.1v104.8h147c-6.1 33.8-25.7 63.7-54.4 82.7v68h87.7c51.5-47.4 81.1-117.4 81.1-200.2z" fill="#4285f4"/>
        <path d="M272.1 544.3c73.4 0 135.3-24.1 180.4-65.7l-87.7-68c-24.4 16.6-55.9 26-92.6 26-71 0-131.2-47.9-152.8-112.3H28.9v70.1c46.2 91.9 140.3 149.9 243.2 149.9z" fill="#34a853"/>
        <path d="M119.3 324.3c-11.4-33.8-11.4-70.4 0-104.2V150H28.9c-38.6 76.9-38.6 167.5 0 244.4l90.4-70.1z" fill="#fbbc04"/>
        <path d="M272.1 107.7c38.8-.6 76.3 14 104.4 40.8l77.7-77.7C405 24.6 339.7-.8 272.1 0 169.2 0 75.1 58 28.9 150l90.4 70.1c21.5-64.5 81.8-112.4 152.8-112.4z" fill="#ea4335"/>
      </svg>
    </div>
    <div style="margin-left: 27px;">
      Sign in with Google
    </div>
  </a>
</div>
```

> We created this from scratch using the SVG of the Google logo
and some basic CSS. <br />
For the "making of" journey see:
https://github.com/dwyl/elixir-auth-google/issues/25

The result looks _better_ than the `<img>` button:

![img-vs-svg-8kb-1kb](https://user-images.githubusercontent.com/194400/73607841-54a84d80-45b3-11ea-9d0c-a81005a0bfde.png)

It can be scaled to any screen size so it will _always_ look great! <br />
Using http://bytesizematters.com we see that our SVG+CSS button is only **`1kb`**:
![bytesize-matters-google-button](https://user-images.githubusercontent.com/194400/73607378-4fe09b00-45ad-11ea-9ab1-3b383c1d4516.png)


That is an **87.5%** bandwidth saving
on the **`8kb`** of the
[**`.png`** button](https://github.com/dwyl/elixir-auth-google/issues/25).
And what's _more_ it reduces the number of HTTP requests
which means the page loads _even_ faster.

This is used in the Demo app:
[`lib/app_web/templates/page/index.html.eex`](https://github.com/dwyl/elixir-auth-google-demo/blob/4fdbeada2f13f4dd27d2372a916764ec7aad24e7/lib/app_web/templates/page/index.html.eex#L5-L26)


### `i18n`

The _biggest_ advantage of having an SVG+CSS button
is that you can _translate_ the button text! <br />
Since the text/copy of the button is now _just_ text in standard HTML,
the user's web browser can _automatically_ translate it! <br />
e.g: _French_ 🇬🇧 > 🇫🇷

![google-login-french-translation](https://user-images.githubusercontent.com/194400/73607961-c03eea80-45b4-11ea-9840-5d5f02ff8a13.png)

This is _much_ better UX for the **80%** of people in the world
who do _not_ speak English _fluently_.
The _single_ biggest engine for growth in startup companies
is [_translating_](https://youtu.be/T9ikpoF2GH0?t=463)
their user interface into more languages.
Obviously don't focus on translations
while you're building your MVP,
but if it's no extra _work_
to use this SVG+CSS button
and it means the person's web browser
can _automatically_ localise your App!

### _Accessibility_

The `SVG+CSS` button is more accessible than the image.
Even thought the `<img>` had an `alt` attribute
which is a lot better than nothing,
the `SVG+CSS` button can be re-interpreted
by a non-screen device and more easily transformed.


<br /> <br />

## _Even_ More Detail 💡

If you want to dive a bit deeper into _understanding_ how this package works,
You can read and grok the code in under 10 minutes:
[`/lib/elixir_auth_google.ex`](https://github.com/dwyl/elixir-auth-google/blob/master/lib/elixir_auth_google.ex)

We created a _basic_ demo Phoenix App,
to show you _exactly_ how you can implement
the **`elixir_auth_google`** package:
https://github.com/dwyl/elixir-auth-google-demo
It's deployed to Heroku: https://elixir-auth-google-demo.herokuapp.com <br />
(_no data is saved so you can play with it - and try to break it!_)

And if you want/need a more complete real-world example
including creating sessions and saving profile data to a database,
take a look at our MVP:
https://github.com/dwyl/app-mvp-phoenix


<br /><br />

## Notes 📝

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
