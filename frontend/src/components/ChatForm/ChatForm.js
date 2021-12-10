import React from 'react';
import { Component } from 'react';

import './ChatForm.css';


class ChatForm extends Component {
    render(){
    return (
        <div id="chat-form">
            <input type="text" placeholder="type a message"value={this.props.message} onChange={this.props.onChange} onKeyPress={this.props._handleKeyPress} />
        </div>
    );
}
}

export default ChatForm;