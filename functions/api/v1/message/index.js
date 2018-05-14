exports.handler = (event, context, callback) => {
  let res = {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*'
    },
    body: JSON.stringify({
      content: 'Hello, World!'
    })
  }

  callback(null, res)
  console.info(`message function called in ${process.env.ENVIRONMENT}.`)
}
