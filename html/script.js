window.addEventListener('message', function (event) {
    const container = document.querySelector('.noise-container');
    if (event.data.action === "updateNoise") {
        const bar = document.getElementById("noise-bar");
        const noise = Math.min(event.data.noise, 100);
        bar.style.width = noise + "%";
    } 
    else if (event.data.action === "show") {
        container.style.display = "block";
    } 
    else if (event.data.action === "hide") {
        container.style.display = "none";
    }
});