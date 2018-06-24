const { protocol, host } = window.location
const baseUrl = `${protocol}//api.${host}/v1`

export default class Api {
  static async getMessage () {
    try {
      const response = await fetch(`${baseUrl}/message`)
      const body = await response.json()
      return body.content
    } catch (err) {
      console.log('Error getting message.', err)
      throw err
    }
  }
}
