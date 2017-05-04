import React, { Component } from 'react'
import DevTool from 'mobx-react-devtools'
import Box from 'grommet/components/Box'

import { Grid, Row, Col } from 'react-flexbox-grid'

import Header from './Header'
import TopMeters from './TopMeters'
import TimePlot from './TimePlot'
import BottomMeters from './BottomMeters'


import 'grommet/scss/hpe/index'

export default class App extends Component {
  render() {
    const devTool = process.env.NODE_ENV == 'production' ?
                    undefined :
                    <DevTool />

    return (
      <Grid>
      {devTool}
      <Header />
      <TopMeters />

      <TimePlot />

      <BottomMeters />

      </Grid>
    )
  }
}
