import React from 'react'
import renderer from 'react-test-renderer'

import App from '../App'

describe('App', () => {
  it('renders react component', () => {
    const component = renderer.create(<App />)
    const tree = component.toJSON()
    const instance = component.root

    expect(tree).toMatchSnapshot()
  })
})
