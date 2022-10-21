<div align="center">

# `Elixir-Auth-One-Tap`

The _easiest_ way to add the **One tap** Google OAuth authentication to your Elixir Apps.

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

An Elixir package that seamlessly handles Google One tap OAuth2 Authentication/Authorization in as few steps as possible.

Following best practices for security & privacy and avoiding complexity by having sensible defaults for all settings.

> We built a lightweight solution
> that only does _one_ thing
> and is easy for complete beginners to understand/use. <br />
> There were already _several_ available options
> for adding Google Auth to apps on
> [hex.pm/packages?search=google](https://hex.pm/packages?search=google) <br />
> that all added _far_ too many implementation steps (complexity)
> and had incomplete docs (**`@doc false`**) and tests. <br />
> e.g:
> [github.com/googleapis/elixir-google-api](https://github.com/googleapis/elixir-google-api)
> which is a
> ["_generated_"](https://github.com/googleapis/elixir-google-api/blob/master/scripts/generate_client.sh)
> client and is considered "experimental". <br />
> We have drawn inspiration from several sources
> including code from other programming languages to build this package.
> This result is _much_ simpler
> than anything else
> and has both step-by-step instructions
> and a _complete working example_ App
> including how to encrypt tokens for secure storage
> to help you ship your app _fast_.

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

You can add One tap Google Authentication to your Elixir App using **`Elixir_auth_one_tap`** <br />
in under **5 minutes** by following these **5 _easy_ steps**:

## 1. Add the hex package to `deps` 📦

Open your project's **`mix.exs`** file
and locate the **`deps`** (dependencies) section. <br />
Add a line for **`:elixir_auth_one_tap`** in the **`deps`** list:

```elixir
def deps do
  [
    {:elixir_auth_one_tap, "~> 0.0.1"}
  ]
end
```

Once you have added the line to your **`mix.exs`**,
remember to run the **`mix deps.get`** command
in your terminal
to _download_ the dependencies.

## 2. Create Google Project 🆕

Rendez-vous at <https://console.cloud.google.com/>

TODO QUICK
[Create a Google Application if you don't already have one,
generate the OAuth2 Credentials for the application
and save the credentials as environment variables
accessible by your app, or put them in your config file.]

> **Note**: There are a few steps for creating a set of Google APIs credentials,
> so if you don't already have a Google App,
> we created the following step-by-step guide
> to make it quick and _relatively_ painless:
> [create-google-app-guide.md](https://github.com/dwyl/elixir-auth-google/blob/master/create-google-app-guide.md) <br />
> Don't be intimidated by all the buzz-words;
> it's quite straightforward.
> And if you get stuck, ask for
> [help!](https://github.com/dwyl/elixir-auth-google/issues)

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
> They are just here for illustration purposes.

## 4. Create a `OneTapController` in your Project 📝

Create a new file called:
[`lib/app_web/controllers/one_tap_controller.ex`]

Add the following code:

```elixir
defmodule AppWeb.OneTapController do
  use Phoenix.Controller

  action_fallback AppWeb.LoginError

  @doc """
  handles the callback from Google redirect.
  """

  def index(conn, %{"credential" => jwt}) do
    {:ok, profile} =
        GoogleCerts.verified_identity(jwt)

    %{
      email: email,
      name: name,
      google_id: sub,
      picture: pic
    } = profile

    conn
    |> render(:welcome, profile: profile)
  end
end
```

This code does 3 things:

- receives a one-time auth `jwt` sent by Google after the person authenticates.
- verifies the `jwt` against Google's public key and retrives the users credentials
- renders a `:welcome` view displaying some profile data
  to confirm that login with Google was successful.

## 5. Create the `/auth/one_tap` Endpoint 📍

Open your **`router.ex`** file
and locate the section that looks like `scope "/", AppWeb do`

Add the following line:

```elixir
pipeline :api do
  plug(:accepts, ["json"])

  post("/auth/one_tap",
    AppWeb.OneTapController,
    :index
  )
end
```

Sample: [lib/app_web/router.ex#L20](https://github.com/dwyl/elixir-auth-google-demo/blob/4bb616dd134f498b84f079104c0f3345769517c4/lib/app_web/router.ex#L20)

Open your **`app.js`** file and addthe code:

```js
const oneTap = document.querySelector("#g_id_onload");

if (oneTap) {
  oneTap.dataset.login_uri = window.location.href + "auth/one_tap";
}
```

This will add the current domain to the callback URI since Google asks for an absolute path.

## 6. Add the "Login with Google" Button to your Template ✨

You have a controller in the file `lib/app_web/controllers/page_controller.ex` file

```elixir
def index(conn, _params) do
  render(conn, "index.html")
end
```

You need to update the template that this controller servers.
Open the `/lib/app_web/templates/page/index.html.eex` file and paste the following code:

```html
<script
  src="https://accounts.google.com/gsi/client"
  async defer>
</script>

<div id="g_id_onload"
  data-client_id={System.get_env("GOOGLE_CLIENT_ID")}
  data-login_uri=""
  data-auto_prompt="true"
  >
</div>
<div class="flex items-center">
  <div class="g_id_signin"
    data-type="standard"
    data-size="large"
    data-theme="outline"
    data-text="sign_in_with"
    data-shape="rectangular"
    data-logo_alignment="left">
  </div>
</div>
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

TO CHECK
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

**_or_** you can set them as a config variable if you prefer:

```
config :elixir_auth_google,
  :google_scope: "email contacts photoslibrary"
```

With that configured, your App will gain access to the requested services
once the person authenticates/authorizes.

<br /> <br />

## Personalise your button

TODO <https://developers.google.com/identity/gsi/web/reference/html-reference#attribute-types>

### `i18n` ??

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

## _Even_ More Detail 💡

If you want to dive a bit deeper into _understanding_ how this package works, you can read and grok the code in under 2 minutes:
[`/lib/elixir_auth_one_tap.ex`](https://github.com/dwyl/elixir-auth-google/blob/master/lib/elixir_auth_google.ex)

It is heavily based on the library [Joken](https://hexdocs.pm/joken/signers.html) and [Jose](https://hexdocs.pm/jose/JOSE.html).

You can see that we reach for Google certs on each request. This is because Google changes his certs very often (every few hours).
This could be optmised.

And if you want/need a more complete real-world example including creating sessions and saving profile data to a database, take a look at our MVP:
https://github.com/dwyl/app-mvp-phoenix

<br /><br />

## Notes 📝

<https://developers.google.com/identity/gsi/web/guides/overview>

- Official Docs for Google Identity Platform:
  https://developers.google.com/identity/choose-auth
  - Web specific sample code (JS):
    https://developers.google.com/identity/sign-in/web
- Google Sign-In for server-side apps:
  https://developers.google.com/identity/sign-in/web/server-side-flow
- Using OAuth 2.0 for Web Server Applications:
  https://developers.google.com/identity/protocols/OAuth2WebServer
- Google Auth Branding Guidelines:
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

- As of May 2019, there are over
  [2.5 Billion](https://www.theverge.com/2019/5/7/18528297/google-io-2019-android-devices-play-store-total-number-statistic-keynote)
  _active_ Android devices;
  [87%](https://www.idc.com/promo/smartphone-market-share/os) global market share.
  All these people have Google Accounts in order to use Google services.
- YouTube has
  [2 billion](https://www.businessofapps.com/data/youtube-statistics/)
  monthly active YouTube users (_signed in with a Google Account_).
- Gmail has
  [1.5 Billion](https://www.thenewsminute.com/article/googles-gmail-turns-15-now-has-over-15-billion-monthly-active-users-99275)
  monthly active users a
  [27% share](https://seotribunal.com/blog/google-stats-and-facts)
  of the global email client market.
- [65%](https://techjury.net/stats-about/gmail-statistics)
  of Small and Medium sized businesses use Google Apps for business.
- [90%+](https://techjury.net/stats-about/gmail-statistics)
  of startups use Gmail. This is a good _proxy_ for "early adopters".
- [68%](https://eu.azcentral.com/story/opinion/op-ed/joannaallhands/2017/10/09/google-classroom-changing-teachers-students-education/708246001/)
  of schools in the US use Google Classroom and related G-suite products. <br />
  So the _next_ generation of internet/app users have Google accounts.
- Google has
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
