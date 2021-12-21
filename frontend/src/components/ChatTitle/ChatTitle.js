import React from 'react';
import axios from 'axios';
import './ChatTitle.css';


class ChatTitle extends React.Component {
    state={
        client:"",
    }

    componentDidMount() {
        axios.get(`http://localhost:8000/client`)
          .then(res => {
            const client = res.data;
            this.setState({ client: client });
          })
      }
    render(){
    return (
        <div id="chat-title">
            <h2>{this.state.client}</h2>
        </div>
    );
}
}

export default ChatTitle;