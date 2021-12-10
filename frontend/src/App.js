import React from 'react';
import './App.css';
import { BrowserRouter,Routes, Route,Navigate,} from 'react-router-dom';
import ChatShell from './components/Shell/ChatShell';
import Login from './components/Login/Login';

function App(){
  return (
    <BrowserRouter>
      <Routes>
      <Route exact path="/login" element={<Login/>} />
      <Route exact path="/chat" element={<ChatShell/>} />
      <Route exact path="/" element ={<Navigate to = "/login"/>}/>
      </Routes>
    </BrowserRouter>
  );
};

export default App;