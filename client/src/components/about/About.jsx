import React from 'react'

const About = () => (
  <section className="hero is-light is-medium">
    <div className="hero-body">
      <div className="container">
        <div className="content">
          <h1 className="title">About</h1>
          <div className="content">
            <p>This application is built using serverless technologies for backend and React ecosystem for frontend!</p>
            <ul>
              <li><a href="https://www.javascript.com">JavaScript</a></li>
              <li><a href="https://reactjs.org">React</a></li>
              <li><a href="https://aws.amazon.com/lambda">AWS Lambda</a></li>
              <li><a href="https://www.terraform.io">Terraform</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </section>
)

export default About
