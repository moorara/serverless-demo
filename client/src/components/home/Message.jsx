import React from 'react'

const Message = ({ message }) => (
  <section className="hero is-info is-medium">
    <div className="hero-body">
      <div className="container">
        <h1 className="title">Message Panel</h1>
        <div className="content">
          <p>{message}</p>
        </div>
      </div>
    </div>
  </section>
)

export default Message
