var button_start = document.querySelector("#start");
var button_stop = document.querySelector("#stop");
var button_refresh = document.querySelector("#refresh");
var statusText = document.querySelector("#status");

init();

function init() {
	statusText.textContent = "Loading Status...";
	getResponse("https://api.minecraft.benedekkovacs.co.uk/status");

	button_start.addEventListener("click", function () {
		statusText.textContent = "Starting server...";
		getResponse("https://api.minecraft.benedekkovacs.co.uk/start");
	});
	button_stop.addEventListener("click", function () {
		statusText.textContent = "Stopping server...";
		getResponse("https://api.minecraft.benedekkovacs.co.uk/stop");
	});
	button_refresh.addEventListener("click", function () {
		statusText.textContent = "Loading Status...";
		getResponse("https://api.minecraft.benedekkovacs.co.uk/status");
	});
}

async function getResponse(url) {
	responseString = await fetch(url, { method: "GET" })
		.then((response) => response.json())
		.then((responseJson) => JSON.stringify(responseJson))
		.then((responseString) => (statusText.textContent = responseString.split("\\")[1].substring(1)));
}
