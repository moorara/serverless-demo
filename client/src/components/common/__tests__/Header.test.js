import React from 'react'
import renderer from 'react-test-renderer'
import { MemoryRouter } from 'react-router'

import Header from '../Header'

describe('Header', () => {
  test('renders react component with isLoading false', () => {
    const component = renderer.create(
      <MemoryRouter>
        <Header isLoading={false} />
      </MemoryRouter>
    )
    const tree = component.toJSON()
    const instance = component.root

    expect(tree).toMatchSnapshot()
  })
  test('renders react component with isLoading true', () => {
    const component = renderer.create(
      <MemoryRouter>
        <Header isLoading={true} />
      </MemoryRouter>
    )
    const tree = component.toJSON()
    const instance = component.root

    expect(tree).toMatchSnapshot()
  })
})
