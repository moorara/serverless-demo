/* eslint-env mocha */
const should = require('should')

const { handler } = require('../../../../api/v1/message')

describe('api/v1/message', () => {
  let event, context

  beforeEach(() => {
    event = {}
    context = {}
    process.env.ENVIRONMENT = 'test'
  })

  it('should send the message', () => {
    handler(event, context, (err, res) => {
      should.not.exist(err)
      res.statusCode.should.equal(200)
      res.headers['Content-Type'].should.equal('application/json')
      res.headers['Access-Control-Allow-Origin'].should.equal('*')
      res.body.should.equal(JSON.stringify({
        content: 'Hello, World!'
      }))
    })
  })
})
