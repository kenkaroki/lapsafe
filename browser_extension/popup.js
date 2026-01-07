const enabledCheckbox = document.getElementById("enabled");
const siteInput = document.getElementById("siteInput");
const addSiteBtn = document.getElementById("addSite");
const siteList = document.getElementById("siteList");

chrome.storage.sync.get({ enabled: true, allowedSites: [] }, (settings) => {
  enabledCheckbox.checked = settings.enabled;
  renderSites(settings.allowedSites);
});

enabledCheckbox.addEventListener("change", () => {
  chrome.storage.sync.set({ enabled: enabledCheckbox.checked });
});

addSiteBtn.addEventListener("click", () => {
  const site = siteInput.value.trim();
  if (!site) return;

  chrome.storage.sync.get({ allowedSites: [] }, (data) => {
    const updated = [...new Set([...data.allowedSites, site])];
    chrome.storage.sync.set({ allowedSites: updated }, () => {
      siteInput.value = "";
      renderSites(updated);
    });
  });
});

function renderSites(sites) {
  siteList.innerHTML = "";
  sites.forEach((site, index) => {
    const li = document.createElement("li");
    li.textContent = site;
    li.style.cursor = "pointer";
    li.title = "Click to remove";
    li.onclick = () => {
      const updated = sites.filter((_, i) => i !== index);
      chrome.storage.sync.set({ allowedSites: updated }, () =>
        renderSites(updated)
      );
    };
    siteList.appendChild(li);
  });
}
