-module (student_controller).
-behaviour (tuah_controller).

-export ([handle_request/5]).
-export ([before_filter/1]).

-include ("stumana.hrl").

before_filter(_SessionId) ->
    {ok, proceed}.

    % %% do some checking
    % Sid = session_worker:get_cookies(SessionId),
    % case Sid of
    %     {error, undefined} ->
    %         {redirect, <<"/auth/login">>};
    %     _ ->
    %         {ok, proceed}
    % end.

handle_request(<<"GET">>, _Action, _Args, _Params, _Req) ->
    {render, <<"student">>, []};

handle_request(<<"POST">>, <<"add">>, _Args, Params, _Req) ->
    PostVals = maps:get(<<"qs_body">>, Params),
    % -------------------------------------------------------------------------
    %   fields: {
    %     first: 'empty',
    %     last: 'empty',
    %     address1: 'empty',
    %     address2: 'empty',
    %     city: 'empty',
    %     postcode: 'empty',
    %     id_num: 'empty',
    %     student_num: 'empty'
    %   }
    % 
    Student = student_model:new(
            proplists:get_value(<<"card_uid">>, PostVals),
            proplists:get_value(<<"first">>, PostVals),
            proplists:get_value(<<"last">>, PostVals),
            proplists:get_value(<<"address1">>, PostVals),
            proplists:get_value(<<"address2">>, PostVals),
            proplists:get_value(<<"city">>, PostVals),
            proplists:get_value(<<"postcode">>, PostVals),
            proplists:get_value(<<"id_num">>, PostVals),
            proplists:get_value(<<"student_num">>, PostVals)
        ),
    ?INFO("Student data: ~p", [Student]),
    case student_model:save(Student) of
        {ok, _} ->
            ?INFO("Student data is saved", []);
        Err ->
            ?ERROR("Can't save student data, ~p", [Err])
    end,
    {redirect, <<"/student/attendance">>};

handle_request(_, _, _, _, _) ->
    {redirect, <<"/">>}.


