import React from 'react'
import renderer from 'react-test-renderer'

import NotFound from '../NotFound'

describe('NotFound', () => {
  test('renders react component', () => {
    const component = renderer.create(<NotFound />)
    const tree = component.toJSON()
    const instance = component.root

    expect(tree).toMatchSnapshot()
  })
})
