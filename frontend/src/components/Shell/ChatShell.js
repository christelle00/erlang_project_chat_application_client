import React from 'react';

import './ChatShell.css';
import ChatServerMembers from '../ChatServerMembers/ChatServerMembers';
import NewChat from '../ChatServerMembers/NewChat';
import MessageContainer from '../Message/MessageContainer';
import ChatSearch from '../Search/ChatSearch';
import ChatTitle from '../ChatTitle/ChatTitle';
import ChatForm from '../ChatForm/ChatForm';

class ChatShell extends React.Component {
    constructor(props){
        super(props);
        this.state = {"messages": [], "current_message":""}// stores the messsages
        this._handleKeyPress = this._handleKeyPress.bind(this);
        this.onChange = this.onChange.bind(this);
        this.addMessageBox = this.addMessageBox.bind(this);
      }

      addMessageBox(enter=true){
          //////////////////////////////////////////////
          // Ici il faut integrer le send_message du client_server
          //////////////////////////////////////////////
        let messages = this.state.messages;
        let current_message = this.state.current_message;
        console.log(this.state);
        if(current_message && enter){
          messages = [...messages, {"message":current_message}];
          fetch("http://localhost:8080?message=" + current_message)// message reçu par le backend
          .then(res => res.json())
          .then(
            (result) => {
              console.log(result);
              this.setState({
                messages: [...messages, {"message":result["message"], "isothermessage":true}]// message reçu par le client devra être afficher à gauche
              });
            },
            (error) => {
              //rien faire pour l'instant
            }
          );
          current_message = ""
        }  
        this.setState({
          current_message: current_message,
          messages
        });
    
      }

      onChange(e) {
        this.setState({
          current_message: e.target.value
        });  
      }
        // on peut que envoyer des messages avec touche enter
        _handleKeyPress(e) {
        let enter_pressed = false;
        if(e.key === "Enter"){
          enter_pressed = true;
        }
        this.addMessageBox(enter_pressed)
      }
    

 render(){
    return (
        <div id="chat-container">
            <ChatSearch />
            <ChatServerMembers />
            <NewChat />
            <ChatTitle />
            <MessageContainer messages={this.state.messages} />
            <ChatForm _handleKeyPress={this._handleKeyPress} onChange={this.onChange} message={this.state.current_message}  />
        </div>
    );
 }
}

export default ChatShell;