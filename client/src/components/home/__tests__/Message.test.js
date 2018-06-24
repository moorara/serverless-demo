import React from 'react'
import renderer from 'react-test-renderer'

import Message from '../Message'

describe('Message', () => {
  test('renders react component', () => {
    const component = renderer.create(<Message />)
    const tree = component.toJSON()
    const instance = component.root

    expect(tree).toMatchSnapshot()
  })
})
