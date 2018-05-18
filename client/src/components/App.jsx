import 'bulma/css/bulma.css'
import 'font-awesome/css/font-awesome.css'

import React, { Component } from 'react'
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom'

import Header from './common/Header'
import Home from './home/Home'
import About from './about/About'
import NotFound from './common/NotFound'

class App extends Component {
  constructor (props) {
    super(props)
    this.state = {
      isLoading: false
    }
    this.setIsLoading = this.setIsLoading.bind(this)
  }

  setIsLoading (isLoading) {
    this.setState({ isLoading })
  }

  render() {
    return (
      <Router>
        <div>
          <Header isLoading={this.state.isLoading} />
          <Switch>
            <Route exact path="/" render={_ => <Home setIsLoading={this.setIsLoading} />} />
            <Route exact path="/about" component={About} />
            <Route component={NotFound} />
          </Switch>
        </div>
      </Router>
    )
  }
}

export default App
