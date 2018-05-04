import './App.css'
import logo from './logo.png'

import React, { Component } from 'react'

class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Serverless App</h1>
        </header>
        <p className="App-intro">
          Serverless Client Application!
        </p>
      </div>
    )
  }
}

export default App
