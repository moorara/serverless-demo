/* eslint-env mocha */
const should = require('should')

const { handler } = require('../../../../api/v1/message')

describe('api/v1/message', () => {
  let event, context

  beforeEach(() => {
    event = {}
    context = {}
  })

  it('should send the message', () => {
    handler(event, context, (err, res) => {
      should.not.exist(err)
      res.statusCode.should.equal(200)
      res.body.should.equal(JSON.stringify({
        content: 'Hello, World!'
      }))
    })
  })
})
