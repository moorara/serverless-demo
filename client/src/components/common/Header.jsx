import './Header.css'

import React from 'react'
import PropTypes from 'prop-types'
import { Route, NavLink } from 'react-router-dom'

import logo from './logo.png'
import Loading from './Loading'

const TabItem = ({ to, children }) => (
  <Route exact path={to} children={
    ({ location, match }) => (
      <li className={match ? "is-active" : ""}>
        <NavLink to={to} exact activeClassName="is-active">{children}</NavLink>
      </li>
    )
  } />
)

TabItem.propTypes = {
  to: PropTypes.string.isRequired,
  children: PropTypes.string.isRequired
}

const Header = ({ isLoading }) => (
  <section className="hero is-primary is-medium is-bold">
    <div className="hero-head">
      <div className="container">
        <div className="columns">
          <div className="column is-2 is-offset-5">
            { isLoading && <Loading dots={20} interval={100} /> }
          </div>
        </div>
      </div>
    </div>

    <div className="hero-body">
      <div className="container">
        <div className="columns">
          <div className="column is-1">
            <img src={logo} className="app-logo" alt="logo" />
          </div>
          <div className="column">
            <h1 className="title">Serverless Application</h1>
            <h2 className="subtitle">A React client for consuming serverless API!</h2>
          </div>
        </div>
      </div>
    </div>

    <div className="hero-foot">
      <nav className="tabs is-boxed">
        <div className="container">
          <ul>
            <TabItem to="/">Home</TabItem>
            <TabItem to="/about">About</TabItem>
          </ul>
        </div>        
      </nav>
    </div>
  </section>
)

Header.propTypes = {
  isLoading: PropTypes.bool.isRequired
}

export default Header
