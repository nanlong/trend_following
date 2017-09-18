import React from 'react'
import { gql, graphql } from 'react-apollo'

class FutureDetailG extends React.Component {

  dataHandler(data) {
    let result = {}
    result['price'] = this.currency(data['price'])
    result['diff'] = this.currency(data['diff'])
    result['chg'] = data['chg']
    result['open'] = this.currency(data['open'])
    result['close'] = this.currency(data['close'])
    result['high'] = this.currency(data['high'])
    result['low'] = this.currency(data['low'])
    result['pre_close'] = this.currency(data['pre_close'])
    result['volume'] = data['volume'] || '--'
    result['buy_price'] = this.currency(data['buy_price'])
    result['sell_price'] = this.currency(data['sell_price'])
    result['open_positions'] = data['open_positions']
    result['buy_positions'] = data['buy_positions']
    result['sell_positions'] = data['sell_positions']

    result['datetime'] = data['datetime']
    return result
  }

  currency(value) {
    const newValue = parseFloat(value).toFixed(2)
    return isNaN(newValue) ? '--' : newValue
  }

  render() {
    setTimeout(() => this.props.data.refetch(), 5000)
    
    if (this.props.data.loading) {
      return (<div></div>)
    }

    const data = this.dataHandler(this.props.data.gFuture ? this.props.data.gFuture : {})

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
                  <th>最新价：</th>
                  <td>{data.price}</td>
                </tr>
                <tr>
                  <th>开盘价：</th>
                  <td>{data.open}</td>
                </tr>
                <tr>
                  <th>最高价：</th>
                  <td>{data.high}</td>
                </tr>
                <tr>
                  <th>最低价：</th>
                  <td>{data.low}</td>
                </tr>
                <tr>
                  <th>结算价：</th>
                  <td>{data.close}</td>
                </tr>
                <tr>
                  <th>昨结算：</th>
                  <td>{data.pre_close}</td>
                </tr>
                <tr>
                  <th>持仓量：</th>
                  <td>{data.open_positions}</td>
                </tr>
                <tr>
                  <th>成交量：</th>
                  <td>{data.volume}</td>
                </tr>
                <tr>
                  <th>买价：</th>
                  <td>{data.buy_price}</td>
                </tr>
                <tr>
                  <th>卖价：</th>
                  <td>{data.sell_price}</td>
                </tr>
                <tr>
                  <th>买量：</th>
                  <td>{data.buy_positions}</td>
                </tr>
                <tr>
                  <th>卖量：</th>
                  <td>{data.sell_positions}</td>
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
query FutureDetail($symbol: String!){
  gFuture(symbol: $symbol) {
    symbol
    name
    lot_size
    price
    open
    high
    low
    close
    pre_close
    volume
    diff
    chg
    buy_price
    sell_price
    open_positions
    buy_positions
    sell_positions
    trading_unit
    price_quote
    minimum_price_change
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

export default graphql(graphqlQuery, graphqlOptions)(FutureDetailG)