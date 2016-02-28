-module (api_controller).
-behaviour (tuah_controller).

-export ([handle_request/5]).
-export ([before_filter/1]).

-include ("stumana.hrl").

before_filter(_SessionId) ->
    {ok, proceed}.

handle_request(<<"GET">>, <<"students">>, [Uid], _Params, _Req) ->
    ?DEBUG("Uid = ~p", [Uid]),
    Student = student_model:find(Uid),
    ?INFO("Student data: ~p", [Student]),
    {json, Student};

handle_request(<<"POST">>, <<"students">>, _, Params, _Req) ->
    PostVals = maps:get(<<"qs_body">>, Params),
    % -------------------------------------------------------------------------
    %   fields: {
    %     first: 'empty',
    %     last: 'empty',
    %     address1: 'empty',
    %     address2: 'empty',
    %     city: 'empty',
    %     postcode: 'empty',
    %     idnum: 'empty',
    %     studentnum: 'empty'
    %   }
    % 
    Student = student_model:new(
            proplists:get_value(<<"first">>, PostVals),
            proplists:get_value(<<"last">>, PostVals),
            proplists:get_value(<<"address1">>, PostVals),
            proplists:get_value(<<"address2">>, PostVals),
            proplists:get_value(<<"city">>, PostVals),
            proplists:get_value(<<"postcode">>, PostVals),
            proplists:get_value(<<"idnum">>, PostVals),
            proplists:get_value(<<"studentnum">>, PostVals)
        ),
    ?INFO("Student data: ~p", [Student]),
    case Student:save() of
        {ok, _} ->
            {json, [{result, <<"ok">>}]};
        Err ->
            {json, [{result, Err}]}
    end;

handle_request(_, _, _, _, _) ->
    {json, [{result, <<"ok">>}]}.

