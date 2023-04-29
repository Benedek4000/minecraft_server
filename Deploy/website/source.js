var button_start = document.querySelector("#start");
var button_stop = document.querySelector("#stop");
var button_refresh = document.querySelector("#refresh");
var statusText = document.querySelector("#status");

init();

function init() {
	refresh();
	button_start.addEventListener("click", function () {
		start();
	});
	button_stop.addEventListener("click", function () {
		stop();
	});
	button_refresh.addEventListener("click", function () {
		refresh();
	});
}
//problem with incorrect headers
function start() {
	fetch("https://api.minecraft.benedekkovacs.com/start").then((response) => (statusText.textContent = response));
}

function stop() {
	fetch("https://api.minecraft.benedekkovacs.com/stop").then((response) => (statusText.textContent = response));
}

function refresh() {
	fetch("https://api.minecraft.benedekkovacs.com/status").then((response) => (statusText.textContent = response));
}
