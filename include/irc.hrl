% irc header
% defines headers and users for irc

-include("lcie.hrl").
-define(newline, "\r\n").
-define(ircport, 6667).

-define(RPL_WELCOME,        "001"). % Welcome message
-define(RPL_YOURHOST,       "002"). % Info about server
-define(RPL_CREATED,        "003"). % Server was created on <date>
-define(RPL_MYINFO,         "004"). % Info about server
-define(RPL_BOUNCE,         "005"). % Try another server

-define(RPL_USERHOST,       "302").
-define(RPL_ISON,           "303").
-define(RPL_AWAY,           "301"). % User awaymessage
-define(RPL_UNAWAY,         "305"). % You are no longer away
-define(RPL_NOWAWAY,        "306"). % You are now away
-define(RPL_whOISUSER,      "311").
-define(RPL_WHOISSERVER,    "312").
-define(RPL_WHOISOPERATOR,  "313").
-define(RPL_WHOISIDLE,      "317").
-define(RPL_ENDOFWHOIS,     "318").
-define(RPL_WHOISCHANNEL,   "319").
-define(RPL_WHOWASUSER,     "314").
-define(RPL_ENDOFWHOWAS,    "369").
-define(RPL_LISTSTART,      "321"). % Obsolete
-define(RPL_LIST,           "322").
-define(RPL_LISTEND,        "323").
-define(RPL_UNIQOPIS,       "325").
-define(RPL_CHANNELMODEIS,  "324").
-define(RPL_NOTOPIC,        "331").
-define(RPL_TOPIC,          "332").
-define(RPL_INVITING,       "341").
-define(RPL_SUMMONING,      "342").
-define(RPL_INVITELIST,     "346").
-define(RPL_ENDOFINVITELIST,"347").
-define(RPL_EXCEPTLIST,     "348").
-define(RPL_ENDOFEXCEPTLIST,"349").
-define(RPL_VERSION,        "351").
-define(RPL_WHOREPLY,       "352").
-define(RPL_ENDOFWHO,       "315").
-define(RPL_NAMREPLY,       "353").
-define(RPL_ENDOFNAMES,     "366").
-define(RPL_LINKS,          "364").
-define(RPL_ENDOFLINKS,     "365").
-define(RPL_BANLIST,        "367").
-define(RPL_ENDOFBANLIST,   "368").
-define(RPL_INFO,           "371").
-define(RPL_ENDOFINFO,      "374").
-define(RPL_MOTDSTART,      "375").
-define(RPL_MOTD,           "372").
-define(RPL_ENDOFMOTD,      "376").

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

