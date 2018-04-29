exports.handler = (event, context, callback) => {
  let res = {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      message: 'Hello, World!'
    })
  }

  callback(null, res)
  console.info('hello-world function called.')
}
