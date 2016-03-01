-module (student_model).
-include ("stumana.hrl").

-define (DB, <<"students">>).

-export ([new/9, save/1, find/1]).
-export ([ensure_index/0]).


  % $('.ui.form').form({
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
  % });   

new(Uid, FirstName, LastName, Address1, Address2, City, Postcode, IdNum, StudentNum) ->
    #{<<"_id">> => uuid:gen(),
      <<"card_uid">> => Uid,
      <<"first">> => FirstName,
      <<"last">> => LastName,
      <<"address1">> => Address1,
      <<"address2">> => Address2,
      <<"city">> => City,
      <<"postcode">> => Postcode,
      <<"id_num">> => IdNum,
      <<"student_num">> => StudentNum,
      <<"balances">> => 0.0,
      <<"created_at">> => os:timestamp(),
      <<"updated_at">> => os:timestamp()}.

save(Student) ->
    mongo_worker:save(?DB, Student).

find(UID) ->
    case mongo_worker:find_one(?DB, {<<"card_uid">>, UID}, #{}) of
        {error, _} -> [];
        {ok, Student} -> format_ts(Student)
    end.

ensure_index() ->
    mongo_worker:ensure_index(?DB, #{<<"key">> => #{<<"student_num">> => 1},
                                     <<"unique">> => true,
                                     <<"dropDups">> => true}),
    mongo_worker:ensure_index(?DB, #{<<"key">> => #{<<"id_num">> => 1},
                                     <<"unique">> => true,
                                     <<"dropDups">> => true}).

format_ts(Model) ->
    UpdatedTS = [{C, qdate:to_date(maps:get(C, Model))} || C <- [<<"updated_at">>, <<"created_at">>]],
    FixedId = [{<<"id">>, maps:get(<<"_id">>, Model)}],
    ?DEBUG("UpdatedTS = ~p", [UpdatedTS]),
    ?DEBUG("FixedId = ~p", [FixedId]),
    M = maps:merge(Model, maps:from_list(lists:append(UpdatedTS, FixedId))),
    maps:remove(<<"_id">>, M).
    


