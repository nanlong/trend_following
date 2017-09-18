import React from 'react'
import { gql, graphql } from 'react-apollo'


class StockDetailUS extends React.Component {

  currency(value) {
    const newValue = parseFloat(value).toFixed(2)
    return isNaN(newValue) ? 0 : newValue
  }

  aHundredMillion(value) {
    const newValue = (parseFloat(value) / 100000000).toFixed(2)
    return isNaN(newValue) ? 0 : newValue + '亿'
  }

  pn(value) {
    const newValue = parseFloat(value) 
    return newValue > 0 ? '+' + newValue : newValue
  }

  dataHandler(data) {
    let newData = {
      price: this.currency(data.price),
      chg: this.currency(data.chg),
      open: this.currency(data.open),
      preClose: this.currency(data.preClose),
      high: this.currency(data.high),
      low: this.currency(data.low),
      yearHigh: this.currency(data.yearHigh),
      yearHigh: this.currency(data.yearHigh),
      marketCap: this.aHundredMillion(data.marketCap),
      capital: this.aHundredMillion(data.capital),
      chg: this.pn(data.chg),
      diff: this.pn(data.diff)
    }
    
    return Object.assign({}, data, newData)
  }

  render() {
    setTimeout(() => this.props.data.refetch(), 5000)

    if (this.props.data.loading) {
      return (<div></div>)
    }
    
    const data = this.dataHandler(this.props.data.usStock ? this.props.data.usStock : {})
    
    return (
      <div>
        <h1 className={data.chg >= 0 ? 'bull' : 'bear'}>
          <span style={{fontSize: '20px', marginRight: '10px'}}>{data.price}</span>
          <span className="icon">
            <i className={data.chg >= 0 ? 'fa fa-long-arrow-up' : 'fa fa-long-arrow-down'} aria-hidden="true"></i>
          </span>
          <span style={{fontSize: '14px'}}>{data.chg}</span>
          <span style={{fontSize: '14px'}}>({data.diff}%)</span>
        </h1>
        <div>{data.datetime}</div>
        <div className="columns">
          <div className="column">
            <table className="table">
              <tbody>
                <tr>
                  <th>开盘：</th>
                  <td>{data.open}</td>
                </tr>
                <tr>
                  <th>前收盘：</th>
                  <td>{data.preClose}</td>
                </tr>
                <tr>
                  <th>成交：</th>
                  <td>{data.volume}</td>
                </tr>
                <tr>
                  <th>区间：</th>
                  <td>{data.low}-{data.high}</td>
                </tr>
                <tr>
                  <th>10日均量：</th>
                  <td>{data.volumeD10Avg}</td>
                </tr>
                <tr>
                  <th>52周区间：</th>
                  <td>{data.yearLow}-{data.yearHigh}</td>
                </tr>
                <tr>
                  <th>市盈率：</th>
                  <td>{data.pe}</td>
                </tr>
                <tr>
                  <th>市值：</th>
                  <td>{data.marketCap}</td>
                </tr>
                <tr>
                  <th>每股收益：</th>
                  <td>{data.eps}</td>
                </tr>
                <tr>
                  <th>股本：</th>
                  <td>{data.capital}</td>
                </tr>
                <tr>
                  <th>贝塔系数：</th>
                  <td>{data.beta}</td>
                </tr>
                <tr>
                  <th>股息/收益率：</th>
                  <td>{data.dividend}/{data.yield}</td>
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
    usStock(symbol: $symbol) {
      symbol
      price
      chg
      diff
      open
      volume
      volumeD10Avg
      preClose
      high
      low
      yearHigh
      yearLow
      pe
      eps
      beta
      marketCap
      capital
      dividend
      yield
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

export default graphql(graphqlQuery, graphqlOptions)(StockDetailUS)