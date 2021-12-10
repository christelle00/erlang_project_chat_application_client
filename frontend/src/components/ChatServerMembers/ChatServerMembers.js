import React from 'react';

import './ChatServerMembers.css';

class ChatServerMembers extends React.Component {
    render(){
    return (
        <div id="conversation-list">
            <div className="conversation active">
                <div className="title-text">Client1</div>
            </div>
            <div className="conversation">
                <div className="title-text">Client2</div>
            </div>
            <div className="conversation">
                <div className="title-text">Client3</div>
            </div>
        </div>
        
    );
    }
}

export default ChatServerMembers;