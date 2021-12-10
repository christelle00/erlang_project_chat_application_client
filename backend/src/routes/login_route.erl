-module(login_route).

-behaviour(cowboy_rest).

-export([init/2]).

-export([allowed_methods/2]).

-export([content_types_provided/2]).

-export([content_types_accepted/2]).

-export([known_methods/2]).

%% Callback Callbacks
-export([get_login/2]).


init(Req0, State) -> {cowboy_rest, Req0, State}.

allowed_methods(Req, State) ->
    {[<<"GET">>], Req, State}.

content_types_provided(Req, State) ->
    {[{{<<"application">>, <<"json">>, []}, get_book}],
     Req,
     State}.

content_types_accepted(Req, State) ->
    {[{{<<"application">>, <<"json">>, []}, post_book}],
     Req,
     State}.

%get_login(Req0, State0) ->
%    QsVals = cowboy_req:parse_qs(Req0),
%    case lists:keyfind(<<"name">>, 1, QsVals) of
%        {_, undefined} -> Message = {[{response, <<"No login">>}]};
%        {_, NAME} ->
%%            {[{response, chat_client:get(NAME)}]}
%%    {jiffy:encode(Message), Req0, State0}.

login(Req, State) ->
    Message = {[{login, <<"ok">>}]},
    {jiffy:encode(Message), Req, State}.

known_methods(Req, State) ->
    Result = [<<"GET">>],
    {Result, Req, State}.
