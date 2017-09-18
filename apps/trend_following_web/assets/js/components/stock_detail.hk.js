import React from 'react'
import { gql, graphql } from 'react-apollo'

class StockDetailHK extends React.Component {

  dataHandler(data) {
    let result = {}
    result['lot_size'] = data['lot_size']
    result['price'] = this.currency(data['price'])
    result['diff'] = this.currency(data['diff'])
    result['chg'] = data['chg']
    result['pre_close'] = this.currency(data['pre_close'])
    result['open'] = this.currency(data['open'])
    result['amount'] = this.dataAmount(data['amount'])
    result['volume'] = this.dataVolume(data['volume'])
    result['high'] = this.currency(data['high'])
    result['low'] = this.currency(data['low'])
    result['year_high'] = this.currency(data['year_high'])
    result['year_low'] = this.currency(data['year_low'])
    result['amplitude'] = data['amplitude']
    result['pe'] = data['pe']
    result['total_capital'] = this.totalCapital(data['total_capital'])
    result['hk_capital'] = this.hkCapital(data['hk_capital'])
    result['hk_market_cap'] = this.dataMarketCap(data['hk_market_cap'])
    result['dividend_yield'] = data['dividend_yield']
    result['datetime'] = data['datetime']
    return result
  }

  currency(value) {
    const newValue = parseFloat(value).toFixed(3)
    return isNaN(newValue) ? 0 : newValue
  }

  dataVolume(value) {
    let v = value || 0

    if (v > 10000) {
      return (v / 10000).toFixed(3) + '万股'
    }
    else {
      return v + '股'
    }
  }

  dataAmount(value) {
    let v = value || 0

    if (v > 100000000) {
      return (v / 100000000).toFixed(3) + '亿'
    }
    else if (v > 10000) {
      return (v / 10000).toFixed(3) + '万'
    }
    else {
      return v
    }
  }

  dataMarketCap(value) {
    return this.dataAmount(value)
  }

  totalCapital(value) {
    return this.dataAmount(value)
  }

  hkCapital(value) {
    return this.dataAmount(value) 
  }

  render() {
    setTimeout(() => this.props.data.refetch(), 5000)

    if (this.props.data.loading) {
      return (<div></div>)
    }
    
    const data = this.dataHandler(this.props.data.hkStock ? this.props.data.hkStock : {})

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
                  <th>昨收：</th>
                  <td>{data.pre_close}</td>
                </tr>
                <tr>
                  <th>今开：</th>
                  <td>{data.open}</td>
                </tr>
                <tr>
                  <th>成交额：</th>
                  <td>{data.amount}</td>
                </tr>
                <tr>
                  <th>成交量：</th>
                  <td>{data.volume}</td>
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
                  <th>52周最高：</th>
                  <td>{data.year_high}</td>
                </tr>
                <tr>
                  <th>52周最低：</th>
                  <td>{data.year_low}</td>
                </tr>
                <tr>
                  <th>振幅：</th>
                  <td>{data.amplitude}%</td>
                </tr>
                <tr>
                  <th>市盈率：</th>
                  <td>{data.pe}</td>
                </tr>
                <tr>
                  <th>总股本：</th>
                  <td>{data.total_capital}</td>
                </tr>
                <tr>
                  <th>港股本：</th>
                  <td>{data.hk_capital}</td>
                </tr>                
                <tr>
                  <th>每手股数：</th>
                  <td>{data.lot_size}</td>
                </tr>
                <tr>
                  <th>港股市值：</th>
                  <td>{data.hk_market_cap}</td>
                </tr>
                <tr>
                  <th>周息率：</th>
                  <td>{data.dividend_yield}%</td>
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
query stockDetail($symbol: String!){
  hkStock(symbol: $symbol) {
    symbol
    name
    cname
    lot_size
    price
    diff
    chg
    pre_close
    open
    amount
    volume
    high
    low
    year_high
    year_low
    amplitude
    pe
    total_capital
    hk_capital
    hk_market_cap
    dividend_yield
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

export default graphql(graphqlQuery, graphqlOptions)(StockDetailHK)