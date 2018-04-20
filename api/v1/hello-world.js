exports.handler = (event, context, callback) => {
  let res = {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json'
    },
    body: {
      message: 'Hello, World!'
    }
  }

  callback(null, res)
}
