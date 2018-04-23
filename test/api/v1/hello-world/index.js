/* eslint-env mocha */
const should = require('should')

const { handler } = require('../../../../api/v1/hello-world')

describe('api/v1/hello-world', () => {
  let event, context

  beforeEach(() => {
    event = {}
    context = {}
  })

  it('should send hello-world message', () => {
    handler(event, context, (err, res) => {
      should.not.exist(err)
      res.statusCode.should.equal(200)
      res.body.message.should.equal('Hello, World!')
    })
  })
})
