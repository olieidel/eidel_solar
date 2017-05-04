import React, { Component } from 'react'
import { observable, action } from 'mobx'
import { inject, observer } from 'mobx-react'
import moment from 'moment'

import { Row, Col } from 'react-flexbox-grid'
import Header from 'grommet/components/Header'
import Title from 'grommet/components/Title'
import Box from 'grommet/components/Box'
import Search from 'grommet/components/Search'
import Label from 'grommet/components/Label'
import Sun from 'grommet/components/icons/base/Actions'
import Clock from 'grommet/components/icons/base/Clock'
import Tip from 'grommet/components/Tip'
import Meter from 'grommet/components/Meter'
import Value from 'grommet/components/Value'
import Animate from 'grommet/components/Animate'

moment.locale('de-DE')

@inject('dataStore', 'metersStore')
@observer
class SolarHeader extends Component {
  @observable showStatus = false
  @observable loading = true
  @action changeShowStatus = (status) => this.showStatus = status
  @action setLoading = (value) => this.loading = value
  @action setLoadingAsync = async (value, delay) => {
    setTimeout(() => this.setLoading(value), delay)
  }

  componentWillReact() {
    const { dataStore, metersStore } = this.props
    const loading = dataStore.loading || metersStore.loading
    if(!loading) {
      this.setLoadingAsync(false, 1000)
    }
  }

  render() {
    const { dataStore, metersStore } = this.props
    const { dataSeries } = dataStore

    const loadingProgress = 0 + (dataStore.loading == true ? 0 : 1) +
                             (metersStore.loading == true ? 0 : 1)

    const lastUpdate = dataStore.lastUpdate

    const statusIcon = dataStore.powerNow <= 0 ?
                       (<Clock
                         onMouseOver={() => this.changeShowStatus(true)}
                         onMouseOut={() => this.changeShowStatus(false)}
                         />)
                     : (<Sun
                       onMouseOver={() => this.changeShowStatus(true)}
                       onMouseOut={() => this.changeShowStatus(false)}
                       />)
    const statusTipText = dataStore.powerNow <= 0 ?
                          'System schläft'
                        : 'Alle Systeme OK'
    const statusTip = this.showStatus ?
                      (<Tip target="title" onClose={() => this.changeShowStatus(false)}>
                        {statusTipText}
                        </Tip>)
                    : false

    return (
      <Row><Col xs={12}>
      <Header>

      <Title
      id="title"
      onMouseOver={() => this.changeShowStatus(true)}
      onMouseOut={() => this.changeShowStatus(false)}
      >
      EidelSolar
      </Title>

      {statusIcon}
      {statusTip}

      <Box flex={true}
      justify="center"
      direction="row"
      responsive={true}>

      <Animate
      visible={this.loading}
      enter={{animation: "fade", duration: 0, delay: 0}}
      leave={{animation: "fade", duration: 2500, delay: 0}}
      >
      <Meter
      type="bar"
      label="Lade Daten.."
      value={loadingProgress}
      max={2} />
      </Animate>

      </Box>

      <Box flex={false}
      justify="end"
      direction="row"
      responsive={false}>
      <Label>Letztes Update {moment(lastUpdate).fromNow()}</Label>
      </Box>

      </Header>
      </Col></Row>
    )
  }
}

export default SolarHeader
