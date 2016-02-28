-module (home_controller).
-behaviour (tuah_controller).

-export ([handle_request/5]).
-export ([before_filter/1]).

-include ("stumana.hrl").

before_filter(_SessionId) ->
    {ok, proceed}.

handle_request(<<"GET">>, _Action, _Args, Params, _Req) ->
    Username = maps:get(<<"auth">>, Params),
    {render, <<"home">>, [{user, Username}, {menu_home, <<"active">>}]}.

