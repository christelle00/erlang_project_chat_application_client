import React from "react";
import MessageList from "./MessageList";

import './MessageContainer.css';

class MessageContainer extends React.Component{
    constructor(props) {
        super(props);
        this.createMessages = this.createMessages.bind(this);
      }

      createMessages(){
        console.log(this.props.messages);
        return this.props.messages.map((message, index) =>
           <MessageList key={index} message={message["message"]} appearance={message["isothermessage"] ? "other-message": "you-message"}/>
        );
      }
    render(){
        return(
          <div id="chat-message-list">
            <ul>
            {this.createMessages()}
            </ul>
          </div>
        );
    }
}
export default MessageContainer;