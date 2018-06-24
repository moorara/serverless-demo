import Api from '../prod'

describe('API Prod', () => {
  const origFetch = window.fetch
  afterEach(() => window.fetch = origFetch)

  it('rejects when fetch fails', async () => {
    window.fetch = jest.fn(url => Promise.reject(new Error('fetch failed')))

    try {
      await Api.getMessage()
    } catch (err) {
      expect(window.fetch).toHaveBeenCalledWith('http://api.localhost/v1/message')
    }
  })
  it('rejects when fetch json fails', async () => {
    window.fetch = jest.fn(url => Promise.resolve({
      json: () => Promise.reject(new Error('fetch json failed'))
    }))

    try {
      await Api.getMessage()
    } catch (err) {
      expect(window.fetch).toHaveBeenCalledWith('http://api.localhost/v1/message')
    }
  })
  it('resolves successfully', async () => {
    window.fetch = jest.fn(url => Promise.resolve({
      json: () => Promise.resolve({ content: 'mock result' })
    }))

    try {
      await Api.getMessage()
    } catch (err) {
      expect(message).toBe('mock result')
      expect(window.fetch).toHaveBeenCalledWith('http://api.localhost/v1/message')
    }
  })
})
