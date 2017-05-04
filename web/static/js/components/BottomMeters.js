import React, { Component } from 'react'
import { inject, observer } from 'mobx-react'
import { Row, Col } from 'react-flexbox-grid'
import Meter from 'grommet/components/Meter'
import Value from 'grommet/components/Value'
import AnnotatedMeter from 'grommet-addons/components/AnnotatedMeter'


const BottomMeters = ({metersStore}) => {
  const createLabel = (label, value, units) => (<Value
    label={label}
    value={value}
    units={units}
    size="small" />)
  const createMeter = (label, value, max) => (<Meter
    type="arc"
    size="small"
    label={label}
    value={value}
    max={max} />)

  const label_dc_1_u = createLabel("DC1", metersStore.dc1_u, "V")
  const meter_dc_1_u = createMeter(label_dc_1_u, metersStore.dc1_u, 460)
  const label_dc_1_i = createLabel("DC1", metersStore.dc1_i, "A")
  const meter_dc_1_i = createMeter(label_dc_1_i, metersStore.dc1_i, 2)
  const label_dc_2_u = createLabel("DC2", metersStore.dc2_u, "V")
  const meter_dc_2_u = createMeter(label_dc_2_u, metersStore.dc2_u, 460)
  const label_dc_2_i = createLabel("DC2", metersStore.dc2_i, "A")
  const meter_dc_2_i = createMeter(label_dc_2_i, metersStore.dc2_i, 2)

  return (
    <div>
    <Row>
    <Col xs={12} sm={6} md={3} lg={3}>
    {meter_dc_1_u}
    </Col>
    <Col xs={12} sm={6} md={3} lg={3}>
    {meter_dc_1_i}
    </Col>
    <Col xs={12} sm={6} md={3} lg={3}>
    {meter_dc_2_u}
    </Col>
    <Col xs={12} sm={6} md={3} lg={3}>
    {meter_dc_2_i}
    </Col>
    </Row>
    <Row>

    </Row>
    </div>
  )
}


export default inject('metersStore')(observer(BottomMeters))
