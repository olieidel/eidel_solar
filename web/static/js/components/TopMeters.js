import React, { Component } from 'react'
import { inject, observer } from 'mobx-react'
import { Row, Col } from 'react-flexbox-grid'
import Meter from 'grommet/components/Meter'
import Value from 'grommet/components/Value'
import AnnotatedMeter from 'grommet-addons/components/AnnotatedMeter'


const TopMeters = ({dataStore, metersStore}) => {
  const powerNow = metersStore.power_now || 0
  const powerMax = dataStore.powerMax
  const energyToday = metersStore.energy_today || 0
  const energyDailyMax = dataStore.energyDailyMax
  const energyWeek = dataStore.energyWeek
  const energyWeeklyMax = dataStore.energyWeeklyMax


  const label_1 = (<Value
    label="Leistung jetzt"
    value={powerNow}
    units="W"
    size="small" />)

  const label_2 = (<Value
    label="Energie heute"
    value={energyToday.toFixed(2)}
    units="kWh"
    size="small" />)

  const label_3 = (<Value
    label="Energie 7 Tage"
    value={energyWeek.toFixed(2)}
    units="kWh"
    size="small" />)

  return(
    <Row>

    <Col xs={12} sm={4} md={4} lg={4}>

    <Meter type="circle"
    label={label_1}
    size="small"
    value={powerNow}
    max={powerMax}
    />
    </Col>

    <Col xs={12} sm={4} md={4} lg={4}>
    <Meter type="circle"
    label={label_2}
    size="small"
    value={energyToday}
    max={energyDailyMax}
    />
    </Col>

    <Col xs={12} sm={4} md={4} lg={4}>
    <Meter type="circle"
    label={label_3}
    size="small"
    value={energyWeek}
    max={energyWeeklyMax}
    />
    </Col>

    </Row>
  )
}

export default inject('dataStore', 'metersStore')(observer(TopMeters))
