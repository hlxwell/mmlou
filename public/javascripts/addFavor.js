function addFavor(title, url){
    if (document.all) 
        window.external.AddFavorite(url, title);
    else 
        if (window.sidebar) 
            window.sidebar.addPanel(title, url, "")
}

function setAsHome(url, obj){
    if (window.netscape) {
        try {
            netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
        } 
        catch (e) {
            return;
        }
        var prefs = Components.classes['@mozilla.org/preferences-service;1'].getService(Components.interfaces.nsIPrefBranch);
        prefs.setCharPref('browser.startup.homepage', url);
    }
    else {
        obj.style.behavior = 'url(#default#homepage)';
        obj.setHomePage(url);
    }
}