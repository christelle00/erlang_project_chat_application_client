-module(chat_client).

-behaviour(gen_server).
-define(SERVER, ?MODULE).

-record(state, {handler_pid}).%like struct: to store a fixed number of elements
-export([start_link/1]).
-export([init/1,send_message/2,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
%-export([get/1]).

%get(NAME) -> gen_server:call(?MODULE, {get, NAME}).

%start_link will spawn and link to a new process a gen_server
% gen_server will be locally registered with the name given to the client
% the name provided by the client is passed as argument of init(Args)
% no further options are used
start_link(Name)->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [{name, Name}], []).

%if registration suceed, init is expected to return {ok,State}, where state is the internal state of the gen_server
%first it stores the names of the clients(in the args)in a tuple
%then it makes a call to the chat_server(globally registerd) by sending a register request with the client name
%if the reply arrived it returns {ok,State} with the pid of the new chat_handler
%otherwise it stops and indicates the occuring error



init(Args) ->
%  Name = proplists:get_value(name, Args),
  {value, {_, Name}} = lists:keysearch(name, 1, Args),
  io:fwrite("Name : ~p ~n", [Name]),
  case gen_server:call({global,chat_server}, {register, Name}) of
    {ok, HandlerPid} ->
      {ok, #state{ handler_pid = HandlerPid}};
    {error, Reason} ->
      io:fwrite("terminating chat_client Reason : ~p ~n", [Reason]),
      {stop, normal}
  end.

%this functions enables sending messages to other clients
%the message includes the atom send and a tuple with the name and the message
send_message(Name,Message)->
  gen_server:call(?SERVER, {send, {Name, Message}}).


handle_call({join, Name}, _From, State) ->
  io:fwrite("~p joined the server ~n", [Name]),
  {reply, ok, State};


%when chat_client receives a request sent, using a call function, it handles it in this function
%here it handles incoming message sent by send_message
%first the internal handler pid int the state of the gen_server process will be stored as HandlerPid
%it will then send the message to the dedicated chat_handler of the client(which will be handled by StateName/2 where StateName is the name of the current state of the gen_fsm)
%{reply,Reply,State} whith the updated state will be returned to the sender
handle_call({send,{Name,Message}},_From,State)->
  io:format("Me : ~p ~n",[Message]),
  HandlerPid= State#state.handler_pid,
  Reply = gen_fsm:send_event(HandlerPid, {send, {Name, Message}}),
  {reply, Reply, State};

handle_call({recieve,{SenderName,Message}},_From, State)->
  io:format("~p : ~p ~n",[SenderName,Message]),
  {reply, ok, State};

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

% callbacks to remove warnings
handle_cast(_Request, State) ->
 {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  io:format("terminating ~p~n",[{local, ?MODULE}]),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
