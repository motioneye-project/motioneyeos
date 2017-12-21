function load_activity(feedurl, divid) {
    var yqlURL = "https://query.yahooapis.com/v1/public/yql";
    var yqlQS = "?q=select%20entry%20from%20xml%20where%20url%20%3D%20'";
    var yqlOPTS = "'%20limit%2010&format=json&callback=";
    var container = document.getElementById(divid);
    var url = yqlURL + yqlQS + encodeURIComponent(feedurl) + yqlOPTS;

    $.getJSON(url, function(data){
        var result = data.query.results;
        var loaded = 0;
        var nb_display = 8;
        if (result==null) return;
        for (var i = 0; i < result.feed.length; i++) {
            var entry = result.feed[i].entry;
            if (entry.title.indexOf("git commit") != -1)
                continue;
            loaded += 1;
            if (loaded > nb_display)
                break;
            var div = document.createElement("p");
            var link = document.createElement("a");
            var d = new Date(entry.published);
            var data = '[' + d.toLocaleDateString() + '] ' + entry.title
            var text = document.createTextNode(data);
            link.appendChild(text);
            link.title = entry.title;
            link.href = entry.link.href;
            div.appendChild(link);
            container.appendChild(div);
        }
        var empty = nb_display - loaded;
        for (var i = 0; i < empty; i++) {
            container.appendChild(document.createElement("p"));
        }
    });
}

function google_analytics() {
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-21761074-1']);
    _gaq.push(['_setDomainName', 'none']);
    _gaq.push(['_setAllowLinker', true]);
    _gaq.push(['_trackPageview']);

    var ga = document.createElement('script');
    ga.type = 'text/javascript';
    ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(ga, s);
}

function showTooltip(elem, msg) {
    elem.setAttribute('class', 'btn tooltipped tooltipped-s');
    elem.setAttribute('aria-label', msg);
}

var clipboard = new Clipboard('.btn');

$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

clipboard.on('success', function(e) {
    e.clearSelection();
    $(e.trigger).tooltip('show');
});

$(function() {
  $('a[href*=\\#]:not([href=\\#])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html,body').animate({
          scrollTop: target.offset().top
        }, 1000);
        return false;
      }
    }
  });
});

jQuery(document).ready(function($) {
    var url = window.location.href;
    // Get the basename of the URL
    url = url.split(/[\\/]/).pop()
    $('.nav a[href="/' + url + '"]').parent().addClass('active');

    load_activity("http://buildroot-busybox.2317881.n4.nabble.com/Buildroot-busybox-ft2.xml", "mailing-list-activity");
    load_activity("http://git.buildroot.org/buildroot/atom/?h=master", "commit-activity");

    $('#slides').html('<iframe src="https://docs.google.com/gview?url=http://free-electrons.com/doc/training/buildroot/buildroot-slides.pdf&embedded=true" style="position:absolute; width:100%; height:100%; top:0; left:0;" frameborder="0"></iframe>')
});
