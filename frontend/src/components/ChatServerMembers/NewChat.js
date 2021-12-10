import React from 'react';

import './NewChat.css';

class NewChat extends React.Component {
    render(){
    return (
        <div id="new-message-container">
            <button className= "new_button">+</button>
        </div>
    );
    }
}

export default NewChat;