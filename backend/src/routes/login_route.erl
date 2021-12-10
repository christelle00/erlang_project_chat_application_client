-module(login_route).

-behaviour(cowboy_rest).

-export([init/2]).

-export([allowed_methods/2]).

-export([content_types_provided/2]).

-export([known_methods/2]).

-export([login/2]).

init(Req, State) -> 
{cowboy_rest, Req, State}.

allowed_methods(Req, State) ->
    {[<<"GET">>], Req, State}.

content_types_provided(Req, State) ->
    {[{{<<"application">>, <<"json">>, []}, login}],
     Req,
     State}.

login(Req, State) ->
    chat_client:start_link("david"),
    Message = {[{login, <<"ok">>}]},
    {jiffy:encode(Message), Req, State}.

known_methods(Req, State) ->
    Result = [<<"GET">>],
    {Result, Req, State}.