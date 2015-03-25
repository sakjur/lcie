% irc header
% defines headers and users for irc

-include("lcie.hrl").
-define(newline, "\r\n").
-define(ircport, 6667).

-define(RPL_WELCOME,    "001"). % Welcome message
-define(RPL_YOURHOST,   "002"). % Info about server
-define(RPL_CREATED,    "003"). % Server was created on <date>
-define(RPL_MYINFO,     "004"). % Info about server
-define(RPL_BOUNCE,     "005"). % Try another server

-define(RPL_USERHOST,   "302").
-define(RPL_ISON,       "303").
-define(RPL_AWAY,       "301"). % User awaymessage
-define(RPL_UNAWAY,     "305"). % You are no longer away
-define(RPL_NOWAWAY,    "306"). % You are now away
-define(RPL_whOISUSER,  "311").
-define(RPL_WHOISSERVER,"312").
-define(RPL_WHOISOPERATOR,"313").

-define(RPL_MOTDSTART,  "375").
-define(RPL_MOTD,       "372").
-define(RPL_ENDOFMOTD,  "376").

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

