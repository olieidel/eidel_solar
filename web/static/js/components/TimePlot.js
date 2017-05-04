import React, { Component } from 'react'
import { observable, action, computed } from 'mobx'
import { observer, inject } from 'mobx-react'
import { Row, Col } from 'react-flexbox-grid'
import { ChartContainer, ChartRow, Charts, YAxis,
         LineChart, AreaChart, Resizable } from 'react-timeseries-charts'

@inject('dataStore')
@observer
class TimePlot extends Component {
  @observable tracker = null
  @observable selectedVal = null
  @observable timerange = this.props.dataStore.dataSeries.timerange()

  @action setTracker = (tracker) => this.tracker = tracker
  @action setSelectedVal = (val) => this.selectedVal = val
  @action setTimeRange = (t) => this.timerange = t

  @computed get selectedValue() {
    if (this.tracker) {
      const { dataSeries } = this.props.dataStore
      const index = dataSeries.bisect(this.tracker)
      const event = dataSeries.at(index)
      return event.get('ac_all_p')
    }
  }

  formatValue = (date, value) => {
    return date.getDate() + "." + (date.getMonth() + 1) + "." + date.getFullYear() + ", " + date.getHours() + ":" + date.getMinutes() + ": " + value + "W"
  }

  componentWillReact() {
    const { dataSeries } = this.props.dataStore
    console.log()
  }

  render() {
    const { dataStore } = this.props
    const { dataSeries } = dataStore

    const formattedValue = this.tracker ?
                           this.formatValue(this.tracker, this.selectedValue) : null

    const style =  {
      value: {
        stroke: "#a02c2c",
        opacity: 0.2
      }
    }

    return(
      <Row>

      <Col xs={12} sm={12} md={12} lg={12}>
      <Resizable>
      <ChartContainer
      timeRange={dataStore.displayTimeRange}
      enablePanZoom={true}
      onTimeRangeChanged={(t) => dataStore.setDisplayTimeRange(t)}
      trackerPosition={this.tracker}
      onTrackerChanged={this.setTracker}
      >
      <ChartRow height={150}>
      <YAxis
      id="y"
      label="Leistung (W)"
      min={0}
      max={dataSeries.max('ac_all_p')}
      width={80}
      format=",.0f" />

      <Charts>
      <AreaChart
      axis="y"
      columns={{up: ["ac_all_p"]}}
      series={dataSeries}
      />
      </Charts>

      </ChartRow>
      </ChartContainer>
      </Resizable>
      </Col>

      <Col xs={12} smOffset={6} sm={6} mdOffset={6} md={6} lgOffset={6} lg={6}>
      {formattedValue}
      </Col>
      </Row>
    )
  }
}

export default TimePlot
