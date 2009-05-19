
function showLoading()
{
    $("body").className  = "loading";
}

function hideLoading()
{
    $("body").className  = "";
}

function hideLoadingAndAlert(message)
{
    $("body").className  = "";
    alert(message)
}

function hideLoadingAndReload(message)
{
    $("body").className  = "";
    alert(message)
    location.reload();
}

function hideLoadingAndRedirect(message,url)
{
    $("body").className  = "";
    alert(message)
    location=url;
}

function stripBadWord(text)
{
    var reBadWords = /他妈的|畜生/gi;   //把badword和anotherbadword设置成对应的要屏蔽的词 
    return text.replace(reBadWords,  function(temp) { return temp.replace(/./g,"*"); });
}