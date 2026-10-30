// Umschalter fuer das Mockup. Die Auswahl wird im localStorage gemerkt,
// damit sie beim Seitenwechsel erhalten bleibt.

var WETTER = {
  sonne:  { icon: "☀", text: "Sonnig",    temp: "21 °C", wind: "Wind 9 km/h",  hinweis: "Keine Hinweise" },
  regen:  { icon: "☂", text: "Regen",     temp: "11 °C", wind: "Wind 14 km/h", hinweis: "Fenster in den Räumen schließen" },
  sturm:  { icon: "⚡", text: "Sturm",     temp: "13 °C", wind: "Wind 62 km/h", hinweis: "Sturmwarnung: Fenster und Dachluken prüfen" },
  schnee: { icon: "❄", text: "Schneefall", temp: "-2 °C", wind: "Wind 12 km/h", hinweis: "Eingänge räumen und streuen" }
};

var STATUS = {
  ok:        { sym: "✓", text: "OK" },
  warnung:   { sym: "▲", text: "Warnung" },
  alarm:     { sym: "✕", text: "Alarm" },
  aus:       { sym: "⊘", text: "Außer Betrieb" },
  unbekannt: { sym: "?", text: "Unbekannt" }
};

var ROLLEN = { lehrkraft: "Lehrkraft", hausmeister: "Hausmeister", admin: "Administrator" };
var NAMEN  = { lehrkraft: "M. Schneider", hausmeister: "K. Weber", admin: "T. Hoffmann" };

function holen(key, standard) {
  try { return localStorage.getItem(key) || standard; } catch (e) { return standard; }
}
function merken(key, wert) {
  try { localStorage.setItem(key, wert); } catch (e) {}
}

function setzeKlasse(praefix, liste, wert) {
  for (var i = 0; i < liste.length; i++) {
    document.body.classList.remove(praefix + liste[i]);
  }
  document.body.classList.add(praefix + wert);
}

function setzeWetter(w) {
  setzeKlasse("wetter-", Object.keys(WETTER), w);
  var d = WETTER[w];
  var chip = document.getElementById("wetter-chip");
  if (chip) chip.textContent = d.icon + " " + d.temp;
  var felder = { "wetter-icon": d.icon, "wetter-text": d.text, "wetter-temp": d.temp,
                 "wetter-wind": d.wind, "wetter-hinweis": d.hinweis };
  for (var k in felder) {
    var el = document.getElementById(k);
    if (el) el.textContent = felder[k];
  }
}

function setzeRolle(r) {
  setzeKlasse("rolle-", Object.keys(ROLLEN), r);
  var n = document.getElementById("nutzer-name");
  var t = document.getElementById("nutzer-rolle");
  if (n) n.textContent = NAMEN[r];
  if (t) t.textContent = ROLLEN[r];
}

function setzeSprache(s) {
  document.documentElement.lang = s;
  var els = document.querySelectorAll("[data-de]");
  for (var i = 0; i < els.length; i++) {
    els[i].textContent = els[i].getAttribute("data-" + s);
  }
}

function setStatus(el, s) {
  var namen = Object.keys(STATUS);
  for (var i = 0; i < namen.length; i++) el.classList.remove("st-" + namen[i]);
  el.classList.add("st-" + s);
  el.setAttribute("data-status", s);
  el.querySelector(".sym").textContent = STATUS[s].sym;
  el.querySelector(".txt").textContent = STATUS[s].text;
}

function setzeAlarm(an) {
  document.body.classList.toggle("alarm-an", an);
  var serverraum = document.getElementById("raum-E04");
  if (serverraum) {
    setStatus(serverraum, an ? "alarm" : "ok");
    serverraum.setAttribute("data-werte", an ? "34,2 °C · 480 ppm · 38 %" : "23,1 °C · 480 ppm · 38 %");
    if (serverraum.classList.contains("gewaehlt")) zeigeRaum(serverraum);
  }
}

// Raumdetail-Panel auf der Geschossseite
function zeigeRaum(tile) {
  var tiles = document.querySelectorAll(".raum");
  for (var i = 0; i < tiles.length; i++) tiles[i].classList.remove("gewaehlt");
  tile.classList.add("gewaehlt");
  var s = tile.getAttribute("data-status");
  document.getElementById("p-titel").textContent =
    tile.querySelector(".nr").textContent + " " + tile.querySelector(".name").textContent;
  document.getElementById("p-werte").textContent = tile.getAttribute("data-werte");
  document.getElementById("p-meld").textContent = tile.getAttribute("data-meld");
  setStatus(document.getElementById("p-badge"), s);
  document.getElementById("raumzustand").value = s;
  document.getElementById("p-sperre").textContent = s === "aus" ? "Sperre aufheben" : "Sperre setzen";
}

document.addEventListener("DOMContentLoaded", function () {
  var rolle = holen("rolle", "hausmeister");
  var wetter = holen("wetter", "sonne");
  var alarm = holen("alarm", "aus");
  var sprache = holen("sprache", "de");

  var selRolle = document.getElementById("rolle");
  var selWetter = document.getElementById("wetter");
  var selAlarm = document.getElementById("alarm");
  var selSprache = document.getElementById("sprache");

  if (selRolle) selRolle.value = rolle;
  if (selWetter) selWetter.value = wetter;
  if (selAlarm) selAlarm.value = alarm;
  if (selSprache) selSprache.value = sprache;

  setzeRolle(rolle);
  setzeWetter(wetter);
  setzeSprache(sprache);
  setzeAlarm(alarm === "an");

  if (selRolle) selRolle.onchange = function () { merken("rolle", this.value); setzeRolle(this.value); };
  if (selWetter) selWetter.onchange = function () { merken("wetter", this.value); setzeWetter(this.value); };
  if (selAlarm) selAlarm.onchange = function () { merken("alarm", this.value); setzeAlarm(this.value === "an"); };
  if (selSprache) selSprache.onchange = function () { merken("sprache", this.value); setzeSprache(this.value); };

  // Geschossauswahl
  var tabs = document.querySelectorAll(".tab");
  for (var i = 0; i < tabs.length; i++) {
    tabs[i].onclick = function () {
      var alle = document.querySelectorAll(".tab, .etage");
      for (var j = 0; j < alle.length; j++) alle[j].classList.remove("aktiv");
      this.classList.add("aktiv");
      document.getElementById(this.getAttribute("data-ziel")).classList.add("aktiv");
    };
  }

  var tiles = document.querySelectorAll(".raum");
  for (var k = 0; k < tiles.length; k++) {
    tiles[k].onclick = function () { zeigeRaum(this); };
  }

  var selZustand = document.getElementById("raumzustand");
  if (selZustand) {
    selZustand.onchange = function () {
      var aktiv = document.querySelector(".raum.gewaehlt");
      if (aktiv) { setStatus(aktiv, this.value); zeigeRaum(aktiv); }
    };
    var start = document.querySelector(".raum.gewaehlt");
    if (start) zeigeRaum(start);
  }
});
