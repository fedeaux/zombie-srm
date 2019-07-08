import React from 'react'
import SurvivorsIndex from './survivors/index.jsx'

class Dashboard extends React.Component {
  render () {
    return (
      <div id='dashboard'>
        <SurvivorsIndex />
      </div>
    )
  }
}

export default Dashboard
