-module(login_route).

-behaviour(cowboy_rest).

-export([init/2]).

-export([allowed_methods/2]).

-export([content_types_provided/2]).

-export([content_types_accepted/2]).

-export([known_methods/2]).

-export([post_login/2]).

init(Req, State) ->
{cowboy_rest, Req, State}.

allowed_methods(Req, State) ->
    {[<<"GET">>,<<"POST">>], Req, State}.

content_types_provided(Req, State) ->
    {[{{<<"application">>, <<"json">>, []}, post_login}],
     Req,
     State}.


 content_types_accepted(Req, State) ->
     {[{{<<"application">>, <<"json">>, []}, post_login}],
      Req,
      State}.

post_login(Req0, _State0) ->
    {ok, EncodedData, _} = cowboy_req:read_body(Req0),
    DecodedData = jiffy:decode(EncodedData),
    case DecodedData of
        {[{<<"name">>, undefined}]} ->
            {Reply, Code} = {{response, <<"undefined attributed">>},204};

        {[{<<"name">>, NAME}]} ->
            %{R, State} = chat_client:start_link(NAME),
            chat_client:start_link(NAME),
            io:format("POST /login name=~p~n", [NAME])
            %Reply = {response, R}
    end,
    %EncodedReply = jiffy:encode({[Reply]}),

    cowboy_req:reply(201, #{<<"content-type">> => <<"application/json">>}, "ok", Req0).

    %cowboy_req:reply(201,
    %                #{<<"content-type">> => <<"application/json">>},
    %                EncodedReply,
    %                Req0).


known_methods(Req, State) ->
    Result = [<<"GET">>,<<"POST">>],
    {Result, Req, State}.
