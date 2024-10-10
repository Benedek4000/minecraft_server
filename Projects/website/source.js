var button_start = document.querySelector("#start");
var button_stop = document.querySelector("#stop");
var button_refresh = document.querySelector("#refresh");
var statusText = document.querySelector("#status");

init();

function init() {
	statusText.textContent = "Loading Status...";
	getResponse("https://${API_DOMAIN_TAG}${SERVER_DOMAIN}${ZONE_NAME}/status");

	button_start.addEventListener("click", function () {
		statusText.textContent = "Starting server...";
		getResponse("https://${API_DOMAIN_TAG}${SERVER_DOMAIN}${ZONE_NAME}/start");
	});
	button_stop.addEventListener("click", function () {
		statusText.textContent = "Stopping server...";
		getResponse("https://${API_DOMAIN_TAG}${SERVER_DOMAIN}${ZONE_NAME}/stop");
	});
	button_refresh.addEventListener("click", function () {
		statusText.textContent = "Loading Status...";
		getResponse("https://${API_DOMAIN_TAG}${SERVER_DOMAIN}${ZONE_NAME}/status");
	});
}

async function getResponse(url) {
	responseString = await fetch(url, { method: "GET" })
		.then((response) => response.json())
		.then((responseJson) => {
			message = JSON.stringify(responseJson);
			statusText.textContent = message.charAt(1).toUpperCase() + message.slice(2, -1);
		});
}
