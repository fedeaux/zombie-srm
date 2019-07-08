import React from 'react'

export default function SurvivorsTableRow(props) {
  return <tr>
    <td> {props.survivor.name} </td>
    <td> {props.survivor.gender} </td>
    <td> {props.survivor.age} </td>
    <td> {props.survivor.points} </td>
  </tr>
}
