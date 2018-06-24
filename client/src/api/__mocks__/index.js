export default class Api {
  static reset() {
    this.mock = {
      getMessage: {
        message: '',
        error: '',
        called: false
      }
    }
  }

  static getMessage () {
    this.mock.getMessage.called = true
    if (this.mock.getMessage.error) {
      return Promise.reject(new Error(this.mock.getMessage.error))
    }
    return Promise.resolve(this.mock.getMessage.message)
  }
}
