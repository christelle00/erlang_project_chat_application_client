-module(chat_fsm).
-behaviour(gen_fsm).

-export([start_link/0]).
-export([callback_mode/0,init/1,connected/2, connected/3, handle_event/3,handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-record(state,{clients,client_pid,name}).


callback_mode() ->
  state_functions.

% a handler is a gen_fsm which is responsible for a chat client
% each has the information about which fsm is serving which client and the whole routing is handled here
start_link() ->
  gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%at initialisation informations are stored in variables and the fsm will be connected and have his state updated
%the return value is {ok,State,Data}
init(Args)->
  Clients= proplists:get_value(clients,Args),
  Name= proplists:get_value(name,Args),
  ClientPid= proplists:get_value(client_pid,Args),
  {ok,connected, #state{clients=Clients,name=Name,client_pid= ClientPid}}.


connected(_Event, _From, State) ->
  {reply, ok, idle, State}.

%handler will have a single state connected(initial state)and handle messages to send to other clients
%first it will take the values from the client
%then if the message has the name of the client it sends the event to the handler of the client which should get the message
connected({send,{ReceiverName,Message}},State)->
  Clients= State#state.clients,
  SenderName= State#state.name,
  case proplists:get_value(ReceiverName,Clients) of
    undefined->
      {error,no_client};
    HandlerPid->
      gen_fsm:send_event(HandlerPid,{recieve,{SenderName,Message}})
  end,
  {next_state, connected, State};

%if message is received, handler has to forward it to its own client
%first the client_pid is taken from the sate
% and then a call is done to the client with the message which will be handled by the handle_call function of chat_client
connected({recieve, {SenderName, Message}}, State) ->
%%io:fwrite("receive ~p ~p ~n",[SenderName, Message]),
  ClientPid = State#state.client_pid,
  gen_server:call(ClientPid, {recieve, {SenderName, Message}}),
 %%ClientPid !  {recieve, SenderName, Message},
  {next_state, connected, State};

%in case of other events, don't take care
connected(_Event,  State) ->
  {next_state, connected, State}.

%call back of gen_statem:call(UserPid, {join, {Name, Pid}}) from chat_server
handle_event({join, {Name, Pid}}, StateName, State) ->
  Clients = lists:concat([State#state.clients, [{Name, Pid}]]),
  ClientPid = State#state.client_pid,
  case gen_server:call(ClientPid, {join, Name}) of
    ok ->
      NewState = State#state{ clients = Clients},
      {next_state, StateName, NewState};
    _Error ->
      ClientName = State#state.name,
      io:fwrite("error connecting client ~p ~n",[ClientName]),
      {stop, normal, State}
    end;
handle_event(_Event, StateName, State) ->
  {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
  Reply = ok,
  {reply, Reply,StateName, State}.

handle_info(_Info, StateName, State) ->
  {next_state, StateName, State}.

terminate(_Reason, _StateName, _State) ->
  ok.

code_change(_OldVsn, StateName, State, _Extra) ->
  {ok, StateName, State}.
