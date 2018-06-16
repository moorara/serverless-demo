jest.useFakeTimers()
import Api from '../dev'

describe('API Dev', () => {
  it('resolves mock result', done => {
    Api.getMessage().then(message => {
      expect(message).toBe('Hello, World!')
      expect(setTimeout).toHaveBeenCalledTimes(1)
      done()
    })
    jest.runAllTimers()
  })
})
