-module(chat_server).
-behaviour(gen_server).
-record(state, {clients}).
-export([start_link/0]).
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-define(SERVER, ?MODULE).


%chat_server is algo a gen_server which will handle incoming connections.
start_link() ->
    gen_server:start_link({global, ?SERVER}, ?MODULE, [], []).



% at initialisation no treatement of info
init([]) ->
    {ok, #state{ clients = []}}.
%by getting a register request from a client it will do the following
% first it will store the Pid of the client from which he got the request
% then it stores the value of the handlers
%then it creates a chat_fsm and passes it the handler, the name of the client and its pid
% if the connection was successfull, it stores the handler Pid  to the clients list and broadcast  the new connection to all existing handlers
% otherwise it stops and prints the error which occured


handle_call({register, Name}, From, State) ->
  {ClientPid, _Tag} =  From,
  Clients = State#state.clients,
  case gen_fsm:start_link(chat_fsm, [{clients, Clients}, {name, Name}, {client_pid, ClientPid}], []) of
    {ok, Pid} ->
      NewState = State#state{ clients = lists:concat([Clients, [{Name, Pid}]])},
      lists:foreach(fun({_UserName, UserPid}) -> gen_fsm:send_all_state_event(UserPid, {join, {Name, Pid}}) end, Clients),
      {reply, {ok, Pid}, NewState};
    {error, Reason} ->
      io:fwrite("gen_fsm start_link fail Reason : ~p ~n", [Reason]),
      {stop, normal, State}
  end;

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%to not have the warnings, one has to implement all callbacks of the gen_server
handle_cast(_Request, State) ->
 {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  io:format("terminating ~p~n",[{local, ?MODULE}]),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
