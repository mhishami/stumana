-module (library_controller).
-behaviour (tuah_controller).

-export ([handle_request/5]).
-export ([before_filter/1]).

-include ("stumana.hrl").

before_filter(_SessionId) ->
    {ok, proceed}.

handle_request(_, _, _, _, _) ->
    {redirect, <<"/">>}.

