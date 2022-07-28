{ config, pkgs, ... }:

{
  networking.extraHosts = ''
    # ---------------------------------------------------
    # Reddit
    # ---------------------------------------------------

    151.101.129.140   i.redditmedia.com
    52.34.230.181     www.reddithelp.com
    151.101.65.140    g.redditmedia.com
    151.101.65.140    a.thumbs.redditmedia.com
    151.101.1.140     redditgifts.com
    151.101.1.140     i.redd.it
    151.101.1.140     old.reddit.com
    151.101.1.140     new.reddit.com
    151.101.129.140   reddit.com
    151.101.129.140   gateway.reddit.com
    151.101.129.140   oauth.reddit.com
    151.101.129.140   sendbird.reddit.com
    151.101.129.140   v.redd.it
    151.101.1.140     b.thumbs.redditmedia.com
    151.101.1.140     events.reddit.com
    54.210.123.98     stats.redditmedia.com
    151.101.65.140    www.redditstatic.com
    151.101.193.140   www.reddit.com
    52.3.23.26        pixel.redditmedia.com
    151.101.65.140    www.redditmedia.com
    151.101.193.140   about.reddit.com
    151.101.1.140     out.reddit.com
    107.23.236.34     events.redditmedia.com
    151.101.61.140    e.reddit.com
    54.84.177.104     alb.reddit.com
    151.101.197.140   s.redditmedia.com
    34.207.103.54     sendbirdproxy-06490ff42851cbcc5.chat.redditmedia.com
    52.207.213.188    sendbirdproxy-003d8d1fb8653f6f8.chat.redditmedia.com
    34.226.121.89     sendbirdproxy-04ea6c3f71aac3e3f.chat.redditmedia.com
  '';
}
