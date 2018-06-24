const delay = 2000

export default class Api {
  static getMessage () {
    return new Promise((resolve, reject) => {
      setTimeout(() => resolve('Hello, World!'), delay)
    })
  }
}
