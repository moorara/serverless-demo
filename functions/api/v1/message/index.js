exports.handler = (event, context, callback) => {
  let res = {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      content: 'Hello, World!'
    })
  }

  callback(null, res)
  console.info('message function called.')
}
