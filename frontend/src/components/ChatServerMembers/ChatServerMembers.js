import React from 'react';

import './ChatServerMembers.css';
import axios from 'axios';

class ChatServerMembers extends React.Component {
    state={
        clients:[],
    }

    componentDidMount() {
        axios.get(`http://localhost:8080/clients`)
          .then(res => {
            const clients = res.data;
            this.setState({ clients: clients });
          })
      }
    render(){
    return (

        <div id="conversation-list">
        {this.state.clients.map(client =>
            <div className="conversation" key={client.toString()}>
                <div className="title-text">{client}</div>
            </div>      
            )}
        </div>
    );
    }
}

export default ChatServerMembers;