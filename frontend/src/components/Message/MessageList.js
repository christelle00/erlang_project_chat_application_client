import React from 'react';

import './MessageList.css';

class MessageList extends React.Component {

    render(){
    return (

            <div className={`message-row ${this.props.appearance}`}>
                    <div className="message-text">
                     {this.props.message}
                    </div>
            </div>
       
    );
    }
}

export default MessageList;