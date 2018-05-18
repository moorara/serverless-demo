import PropTypes from 'prop-types'
import React, { Component } from 'react'

import Api from '../../api'
import Message from './Message'

class Home extends Component {
  static propTypes = {
    setIsLoading: PropTypes.func.isRequired
  }

  constructor (props) {
    super(props)
    this.state = {
      message: ''
    }
  }

  async componentDidMount () {
    this.props.setIsLoading(true)
    try {
      let message = await Api.getMessage()
      this.setState({ message })
    } catch (err) {
      console.log(err)
    }
    this.props.setIsLoading(false)
  }

  render () {
    return (
      <Message content={this.state.message} />
    )
  }
}

export default Home
