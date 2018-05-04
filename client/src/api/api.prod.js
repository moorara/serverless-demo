const { protocol, host } = window.location
const baseUrl = `${protocol}//api.${host}/v1`

export default class Api {
  static async getMessage () {
    try {
      const response = await fetch(`${baseUrl}/hello-world`)
      const body = await response.json()
      return body.message
    } catch (err) {
      console.log('Error getting message', err)
    }
  }
}
