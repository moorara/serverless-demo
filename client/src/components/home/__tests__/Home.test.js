import React from 'react'
import renderer from 'react-test-renderer'

jest.mock('../../../api')
import Api from '../../../api'
import Home from '../Home'

describe('Home', () => {
  let setIsLoading

  beforeEach((() => {
    Api.reset()
    setIsLoading = jest.fn()
  }))

  test('renders react component when api call fails', done => {
    Api.mock.getMessage.error = 'api failure is mocked!'
    const component = renderer.create(<Home setIsLoading={setIsLoading} />)

    // Wait for componentDidMount
    setImmediate(() => {
      const tree = component.toJSON()
      expect(tree).toMatchSnapshot()

      expect(setIsLoading.mock.calls.length).toBe(2)
      expect(setIsLoading.mock.calls[0][0]).toBe(true)
      expect(setIsLoading.mock.calls[1][0]).toBe(false)
      done()
    })
  })
  test('renders react component when api call succeeds', done => {
    Api.mock.getMessage.message = 'Hello, Mock!'
    const component = renderer.create(<Home setIsLoading={setIsLoading} />)

    // Wait for componentDidMount
    setImmediate(() => {
      const tree = component.toJSON()
      expect(tree).toMatchSnapshot()

      expect(setIsLoading.mock.calls.length).toBe(2)
      expect(setIsLoading.mock.calls[0][0]).toBe(true)
      expect(setIsLoading.mock.calls[1][0]).toBe(false)
      done()
    })
  })
})
