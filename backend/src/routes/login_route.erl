-module(login_route).

-behaviour(cowboy_rest).

-export([init/2]).

-export([allowed_methods/2]).


-export([content_types_accepted/2]).

-export([known_methods/2]).

%% Callback Callbacks

-export([post_name/2]).% init(Req0, Opts) ->

init(Req0, State) -> {cowboy_rest, Req0, State}.

allowed_methods(Req, State) ->
    {[<<"POST">>], Req, State}.


content_types_accepted(Req, State) ->
    {[{{<<"application">>, <<"json">>, []}, post_name}],
     Req,
     State}.



post_name(Req0, _State0) ->
    {ok, EncodedData, _} = cowboy_req:read_body(Req0),
    DecodedData = jiffy:decode(EncodedData),
    io:format("Dec:~p~n",[DecodedData]),
    case DecodedData of
        {[{<<"name">>,undefined}]}->
            {Reply, _} = {{response, <<"undefined attributed">>},
                             204};

       {[{<<"name">>,Name}]} ->
            chat_client:start_link(Name),
            io:format("POST /login name=~p~n", [Name]),
            Reply = {response, ok}
    end,
    EncodedReply = jiffy:encode({[Reply]}),
    cowboy_req:reply(ok,
                     #{<<"content-type">> => <<"application/json">>},
                     EncodedReply,
                     Req0).
   
   

known_methods(Req, State) ->
    Result = [<<"POST">>],
    {Result, Req, State}.