function load_activity(feedurl, divid) {
    var feed = new google.feeds.Feed(feedurl);
    var container = document.getElementById(divid);
    var loaded = 0;
    var nb_display = 8;
    feed.setNumEntries(30);
    feed.load(function(result) {
        if (result.error) {
        	return;
        }
        for (var i = 0; i < result.feed.entries.length; i++) {
            var entry = result.feed.entries[i];
            if (entry.title.indexOf("git commit") != -1)
                continue;
            loaded += 1;
            if (loaded > nb_display)
                break;
            var div = document.createElement("p");
            var link = document.createElement("a");
            var d = new Date(entry.publishedDate);
            var data = '[' + d.toLocaleDateString() + '] ' + entry.title
            var text = document.createTextNode(data);
            link.appendChild(text);
            link.title = entry.title;
            link.href = entry.link
            div.appendChild(link);
            container.appendChild(div);
        }
        var empty = nb_display - loaded;
        for (var i = 0; i < empty; i++) {
            container.appendChild(document.createElement("p"));
        }
    });
}

function initialize() {
    load_activity("http://rss.gmane.org/topics/excerpts/gmane.comp.lib.uclibc.buildroot", "mailing-list-activity");
    load_activity("http://git.buildroot.org/buildroot/atom/?h=master", "commit-activity");
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

$(function() {
  $('a[href*=#]:not([href=#])').click(function() {
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

google.load("feeds", "1");
google.setOnLoadCallback(initialize);
google_analytics();

jQuery(document).ready(function($) {
    var url = window.location.href;
    // Get the basename of the URL
    url = url.split(/[\\/]/).pop()
    $('.nav a[href="/' + url + '"]').parent().addClass('active');

    $('#slides').html('<iframe src="https://docs.google.com/gview?url=http://free-electrons.com/doc/training/buildroot/buildroot-slides.pdf&embedded=true" style="position:absolute; width:100%; height:100%; top:0; left:0;" frameborder="0"></iframe>')
});

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
  $('a[href*=#]:not([href=#])').click(function() {
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
