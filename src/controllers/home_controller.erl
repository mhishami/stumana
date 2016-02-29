-module (home_controller).
-behaviour (tuah_controller).

-export ([handle_request/5]).
-export ([before_filter/1]).

-include ("stumana.hrl").

before_filter(_SessionId) ->
    {ok, proceed}.

handle_request(<<"GET">>, <<"content">>, _Args, _Params, _Req) ->
    {render, <<"home">>, []};

handle_request(<<"GET">>, <<"cafe">>, _Args, _Params, _Req) ->
    {render, <<"cafe">>, []};

handle_request(_Method, _Action, _Args, _Params, _Req) ->
    {render, <<"layout">>, []}.


