% irc header
% defines headers and users for irc

-include("lcie.hrl").
-define(newline, "\r\n").

-record(server, {
    type=irc,
    host,
    port=6667
}).

-record(ircuser, {
    nickname,
    username,
    realname
}).

