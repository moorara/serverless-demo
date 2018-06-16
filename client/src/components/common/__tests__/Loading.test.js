import React from 'react'
import renderer from 'react-test-renderer'

import Loading from '../Loading'

describe('Loading', () => {
  beforeEach(() => {
    // Calling this also resets previous mocks
    jest.useFakeTimers()
  })

  test('renders react component with default props', () => {
    const component = renderer.create(<Loading />)
    const tree = component.toJSON()
    const instance = component.root

    expect(tree).toMatchSnapshot()

    // Test componentDidMount lifecycle and setInterval methods
    expect(setInterval).toHaveBeenCalledTimes(1)
    expect(setInterval).toHaveBeenLastCalledWith(expect.any(Function), 150)

    // Test callback function passed to setInterval
    const callback = setInterval.mock.calls[0][0]
    callback()

    // Test componentWillUnmount lifecycle and clearInterval methods
    component.unmount()
    expect(clearInterval).toHaveBeenCalledTimes(1)
  })
  test('renders react component with custom props', () => {
    const component = renderer.create(<Loading dots={10} interval={100} />)
    const tree = component.toJSON()
    const instance = component.root

    expect(tree).toMatchSnapshot()

    // Test componentDidMount lifecycle and setInterval methods
    expect(setInterval).toHaveBeenCalledTimes(1)
    expect(setInterval).toHaveBeenLastCalledWith(expect.any(Function), 100)

    // Test callback function passed to setInterval
    const callback = setInterval.mock.calls[0][0]
    callback()

    // Test componentWillUnmount lifecycle and clearInterval methods
    component.unmount()
    expect(clearInterval).toHaveBeenCalledTimes(1)
  })
})
