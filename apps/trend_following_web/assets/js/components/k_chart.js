import React from 'react'
import { gql, graphql } from 'react-apollo'
import echarts from 'echarts'


class KChart extends React.Component {

  markPoint(x, y, color) {
    return {
      coord: [x, y],
      symbol: 'circle',
      symbolSize: 8,
      itemStyle: {
        normal: {
          color: color
        }
      },
      label: {
        normal: {
          show: false
        }
      }
    }
  }

  dataHandler(data) {
    let source = {
      categoryData: [],
      dailykData: [],
      ma5Data: [],
      ma10Data: [],
      ma20Data: [],
      ma30Data: [],
      ma50Data: [],
      ma300Data: [],
      high10Data: [],
      high20Data: [],
      high60Data: [],
      low10Data: [],
      low20Data: [],
      low60Data: [],
      atrData: [],
      pointData: [],
      createPointData: [],
      closePointData: [],
    }

    data.dayk.map(x => {
      const {date, open, close, high, low, ma5, ma10, ma20, ma30, ma50, ma300, high10, high20, 
        high60, low10, low20, low60, atr} = x
      source.categoryData.push(date)
      source.dailykData.push([open, close, low, high])
      source.ma5Data.push(ma5)
      source.ma10Data.push(ma10)
      source.ma20Data.push(ma20)
      source.ma30Data.push(ma30)
      source.high10Data.push(high10)
      source.high20Data.push(high20)
      source.high60Data.push(high60)
      source.low10Data.push(low10)
      source.low20Data.push(low20)
      source.low60Data.push(low60)
      source.atrData.push(atr)
    })

    return source
  }

  setChartOption(data) {
    let series = [
        {
          name: '日K',
          type: 'candlestick',
          data: data.dailykData
        },
        {
          name: 'MA5',
          type: 'line',
          data: data.ma5Data,
          smooth: true,
          showSymbol: false,
          lineStyle: {
            normal: {
              color: '#FC9CB8',
              width: 1
            }
          },
          itemStyle: {
            normal: {
              color: '#FC9CB8'
            }
          }
        },
        {
          name: 'MA10',
          type: 'line',
          data: data.ma10Data,
          smooth: true,
          showSymbol: false,
          lineStyle: {
            normal: {
              color: '#12BDD9',
              width: 1
            }
          },
          itemStyle: {
            normal: {
              color: '#12BDD9'
            }
          }
        },
        {
          name: 'MA20',
          type: 'line',
          data: data.ma20Data,
          smooth: true,
          showSymbol: false,
          lineStyle: {
            normal: {
              color: '#EE2F72',
              width: 1
            }
          },
          itemStyle: {
            normal: {
              color: '#EE2F72'
            }
          }
        },
        {
          name: 'MA30',
          type: 'line',
          data: data.ma30Data,
          smooth: true,
          showSymbol: false,
          lineStyle: {
            normal: {
              color: '#8CBB0D',
              width: 1
            }
          },
          itemStyle: {
            normal: {
              color: '#8CBB0D'
            }
          }
        },
        {
          name: 'ATR',
          type: 'line',
          data: data.atrData,
          xAxisIndex: 1,
          yAxisIndex: 1,
        }
      ]

    let seriesLine = []
    let legendData = ['日K', 'MA5', 'MA10', 'MA20', 'MA30']
    let legendSelected = {}
    
    if (CONFIG['trend'] == 'bull') {
      legendData.push('20日最高')
      seriesLine.push({name: '20日最高', data: data['high20Data'], color: '#23d160'})
  
      legendData.push('10日最低')
      seriesLine.push({name: '10日最低', data: data['low10Data'], color: '#ff3860'})
  
      legendData.push('60日最高')
      seriesLine.push({name: '60日最高', data: data['high60Data'], color: '#00d1b2'})
  
      legendData.push('20日最低')
      seriesLine.push({name: '20日最低', data: data['low20Data'], color: '#ffdb4a'})
  
      legendSelected['60日最高'] = false
      legendSelected['20日最低'] = false
    }
    else {
      legendData.push('20日最低')
      seriesLine.push({name: '20日最低', data: data['low20Data'], color: '#23d160'})
  
      legendData.push('10日最高')
      seriesLine.push({name: '10日最高', data: data['high10Data'], color: '#ff3860'})
  
      legendData.push('60日最低')
      seriesLine.push({name: '60日最低', data: data['low60Data'], color: '#00d1b2'})
  
      legendData.push('20日最高')
      seriesLine.push({name: '20日最高', data: data['high20Data'], color: '#ffdb4a'})
  
      legendSelected['60日最低'] = false
      legendSelected['20日最高'] = false
    }
    

    seriesLine.map(x => {
      const {name, data, color} = x
      series.push({
        name: name,
        type: 'line',
        data: data,
        smooth: true,
        showSymbol: false,
        lineStyle: {
          normal: {
            color: color,
            width: 1
          }
        },
        itemStyle: {
          normal: {
            color: color
          }
        },
        markPoint: {
          data: x.point || []
        }
      })
    })
  
    
    return {
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'cross'
        },
        borderWidth: 1,
        borderColor: '#ccc',
        padding: 10,
        position: function (pos, params, el, elRect, size) {
          let obj = {top: 10}
          obj[['left', 'right'][+(pos[0] < size.viewSize[0] / 2)]] = 30
          return obj;
        },
        extraCssText: 'width: 170px'
      },
      axisPointer: {
        link: {xAxisIndex: 'all'},
        label: {
          backgroundColor: '#777'
        }
      },
      legend: {
        data: legendData,
        selected: legendSelected
      },
      grid: [
        {
          top: '8%',
          left: '4%',
          right: '1%',
          bottom: '25%'
        },
        {
          left: '4%',
          right: '1%',
          top: '82%',
          height: '8%'
        }
      ],
      xAxis: [
        {
          type: 'category',
          data: data.categoryData,
          axisLine: { lineStyle: { color: '#8392A5' } }
        },
        {
          gridIndex: 1,
          type: 'category',
          data: data.categoryData,
          show: false,
        }
      ],
      yAxis: [
        {
          scale: true,
          splitArea: {
            show: true
          }
        },
        {
          gridIndex: 1,
          type: 'value',
        }
      ],
      dataZoom: [
        {
          start: (1 - 120 / data.categoryData.length) * 100,
          end: 100,
          xAxisIndex: [0, 1]
        },
        {
          start: (1 - 120 / data.categoryData.length) * 100,
          end: 100,
          xAxisIndex: [0, 1]
        },
      ],
      series: series
    }
  }

  componentDidUpdate() {
    const data = this.dataHandler(this.props.data)
    const chart = echarts.init(this.refs.kChart)
    const options = this.setChartOption(data)
    chart.setOption(options)
  }

  render() {
    if (this.props.data.loading) {
      return (
        <div style={{width: '100%', height: '500px'}}>
          加载中……
        </div>
      )
    }
    else {
      return (
        <div ref="kChart" style={{width: '100%', height: '500px'}}></div>
      )
    }
  }
}

const graphqlQuery = gql`
  query KChart($symbol: String!){
    dayk(symbol: $symbol) {
      date
      open
      close
      high
      low
      preClose
      volume
      ma5
      ma10
      ma20
      ma30
      ma50
      ma300
      high10
      high20
      high60
      low10
      low20
      low60
      atr
    }
  }
`

const graphqlOptions = {
  options: {
    variables: {symbol: CONFIG['symbol']}
  }
}

export default graphql(graphqlQuery, graphqlOptions)(KChart)