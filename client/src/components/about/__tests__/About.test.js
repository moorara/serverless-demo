import React from 'react'
import renderer from 'react-test-renderer'

import About from '../About'

describe('About', () => {
  test('renders react component', () => {
    const component = renderer.create(<About />)
    const tree = component.toJSON()
    const instance = component.root

    expect(tree).toMatchSnapshot()
  })
})
