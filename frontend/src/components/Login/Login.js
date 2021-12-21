import React from 'react';
import { Link } from 'react-router-dom';
import axios from "axios";

import './Login.css';



class Login extends React.Component {
  state = {
    name: "",
    };

     handleChange = (event) => {
        this.setState({name: event.target.value});
      };

     handleClick = () => {
      axios.post(`http://localhost:8000/login`, {
        name: this.state.name
      })
      .then((response) => {
        console.log(response);
      }, (error) => {
        console.log(error);
      });
    }
    render(){
    return (
    <div className="login-page">
      <div className="form">
          <div className="login-header">
            <h1>LOGIN</h1>
          </div>
          <input type="text" placeholder="name" onChange={this.handleChange.bind(this)}/>
          <Link to="/chat">
            <button type="button" onClick={this.handleClick.bind(this)}>
             login
            </button>
          </Link>

      </div>
    </div>
    );
    }
}

export default Login;
