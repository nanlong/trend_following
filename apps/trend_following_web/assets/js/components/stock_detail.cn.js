import React from 'react'
import { gql, graphql } from 'react-apollo'

class StockDetailCN extends React.Component {

  dataHandler(data) {
    let result = {}
    result['price'] = this.currency(data['price'])
    result['diff'] = this.currency(data['diff'])
    result['chg'] = data['chg']
    result['open'] = this.currency(data['open'])
    result['high'] = this.currency(data['high'])
    result['low'] = this.currency(data['low'])
    result['pre_close'] = this.currency(data['pre_close'])
    result['volume'] = this.dataVolume(data['volume'])
    result['amount'] = this.dataAmount(data['amount'])
    result['market_cap'] = this.dataMarketCap(data['market_cap'])
    result['cur_market_cap'] = this.dataCurMarketCap(data['cur_market_cap'])
    result['amplitude'] = data['amplitude']
    result['turnover'] = data['turnover']
    result['pb'] = data['pb']
    result['pe'] = data['pe']
    result['datetime'] = data['datetime']
    return result
  }

  currency(value) {
    const newValue = parseFloat(value).toFixed(2)
    return isNaN(newValue) ? 0 : newValue
  }

  dataVolume(value) {
    let v = value || 0
    const hand_num = v / 100

    if (hand_num > 10000) {
      return (hand_num / 10000).toFixed(2) + '万手'
    }
    else {
      return hand_num + '手'
    }
  }

  dataAmount(value) {
    let v = value || 0

    if (v > 100000000) {
      return (v / 100000000).toFixed(2) + '亿元'
    }
    else if (v > 10000) {
      return (v / 10000).toFixed(2) + '万元'
    }
    else {
      return v + '元'
    }
  }

  dataMarketCap(value) {
    return this.dataAmount(value)
  }

  dataCurMarketCap(value) {
    return this.dataAmount(value)
  }

  render() {
    setTimeout(() => this.props.data.refetch(), 5000)
    
    if (this.props.data.loading) {
      return (<div></div>)
    }

    const data = this.dataHandler(this.props.data.cnStock ? this.props.data.cnStock : {})

    return (
      <div>
        <h1 className={data.chg >= 0 ? 'bull' : 'bear'}>
          <span style={{fontSize: '20px', marginRight: '10px'}}>{data.price}</span>
          <span className="icon">
            <i className={data.chg >= 0 ? 'fa fa-long-arrow-up' : 'fa fa-long-arrow-down'} aria-hidden="true"></i>
          </span>
          <span style={{fontSize: '14px'}}>{data.diff}</span>
          <span style={{fontSize: '14px'}}>({data.chg}%)</span>
        </h1>
        <div>{data.datetime}</div>
        <div className="columns">
          <div className="column">
            <table className="table">
              <tbody>
                <tr>
                  <th>今开：</th>
                  <td>{data.open}</td>
                </tr>
                <tr>
                  <th>最高：</th>
                  <td>{data.high}</td>
                </tr>
                <tr>
                  <th>最低：</th>
                  <td>{data.low}</td>
                </tr>
                <tr>
                  <th>昨收：</th>
                  <td>{data.pre_close}</td>
                </tr>
                <tr>
                  <th>成交量：</th>
                  <td>{data.volume}</td>
                </tr>
                <tr>
                  <th>成交额：</th>
                  <td>{data.amount}</td>
                </tr>
                <tr>
                  <th>总市值：</th>
                  <td>{data.market_cap}</td>
                </tr>
                <tr>
                  <th>流通市值：</th>
                  <td>{data.cur_market_cap}</td>
                </tr>
                <tr>
                  <th>振幅：</th>
                  <td>{data.amplitude}%</td>
                </tr>
                <tr>
                  <th>换手率：</th>
                  <td>{data.turnover}%</td>
                </tr>
                <tr>
                  <th>市净率：</th>
                  <td>{data.pb}</td>
                </tr>
                <tr>
                  <th>市盈率：</th>
                  <td>{data.pe}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    )
  }
}

const graphqlQuery = gql`
query CNStockDetail($symbol: String!){
  cnStock(symbol: $symbol) {
    symbol
    name
    price
    open
    high
    low
    pre_close
    volume
    amount
    market_cap
    cur_market_cap
    turnover
    pb
    pe
    diff
    chg
    amplitude
    datetime
    timestamp
  }
}
`

const graphqlOptions = {
  options: {
    fetchPolicy: 'network-only',
    variables: {symbol: CONFIG['symbol']}
  }
}

export default graphql(graphqlQuery, graphqlOptions)(StockDetailCN)