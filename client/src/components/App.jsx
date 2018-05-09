import 'bulma/css/bulma.css'
import 'font-awesome/css/font-awesome.css'

import React, { Component } from 'react'
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom'

import Header from './common/Header'
import Home from './home/Home'
import About from './about/About'
import NotFound from './common/NotFound'

class App extends Component {
  render() {
    return (
      <Router>
        <div>
          <Header isLoading={true} />
          <Switch>
            <Route exact path="/" component={Home} />
            <Route exact path="/about" component={About} />
            <Route component={NotFound} />
          </Switch>
        </div>
      </Router>
    )
  }
}

export default App
