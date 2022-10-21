// Google want an absolute path URL for the callback
const oneTap = document.querySelector("#g_id_onload");

if (oneTap) {
  oneTap.dataset.login_uri = window.location.href + "auth/one_tap";
}
