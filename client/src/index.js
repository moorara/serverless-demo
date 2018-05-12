import './index.css'

import React from 'react'
import ReactDOM from 'react-dom'

import Api from './api'
import App from './components/App'
import registerServiceWorker, { unregister } from './serviceWorker'

Api.getMessage().then(console.log)

ReactDOM.render(<App />, document.getElementById('root'))
unregister()
