import React from 'react'
import SurvivorsTableRow from './table/row.jsx'

class SurvivorsIndex extends React.Component {
  constructor (props) {
    super(props);
    this.state = {
      page: 0,
      survivors: []
    }
  }

  survivorsLoaded = (response) => {
    this.setState({
      survivors: response.survivors
    })
  }

  loadSurvivors () {
    $.get('api/v1/survivors.json', this.survivorsLoaded)
  }

  componentDidMount () {
    this.loadSurvivors()
  }

  componentWillUnmount () {
    console.log('to aprendendo react');
  }

  render () {
    let rows = this.state.survivors.map((survivor) =>
      <SurvivorsTableRow survivor={survivor} key={survivor.id}></SurvivorsTableRow>
    )

    return (
      <table id='survivors-index' onClick={this.titleClicked}>
        <thead>
          <tr>
            <th> Name </th>
            <th> Gender </th>
            <th> Age </th>
            <th> Points </th>
          </tr>
        </thead>
        <tbody>
          {rows}
        </tbody>
      </table>
    )
  }
}

export default SurvivorsIndex
