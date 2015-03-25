% irc header
% defines headers and users for irc

-include("lcie.hrl").
-define(newline, "\r\n").
-define(ircport, 6667).

-record(server, {
    type=irc,
    host,
    port=?ircport
}).

-record(ircuser, {
    nickname,
    username,
    realname
}).

