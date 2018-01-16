import React, {Component} from 'react';
import SearchInput, {createFilter} from 'react-search-input'
import _ from 'lodash';

import data from './data'
import topCoins from './top-coins'
import topMarkets from './top-markets'

const KEYS_TO_FILTERS = ['code','name']

class TopCoinsTable extends Component {

  onClickCoin = (code) => {
    this.props.onClickCoin(code);
  }

  render () {
    const coins = topCoins.map((coin, key) => {
      return (
        <tr key={key}>
          <td onClick={this.onClickCoin.bind(this, coin.code)}>{coin.name}</td>
          <td>{coin.code}</td>
        </tr>
      )
    });
    return (
      <table>
        <thead>
          <tr>
            <th colSpan="999">Top Coins</th>
          </tr>
        </thead>
        <tbody>
          {coins}
        </tbody>
      </table>
    );
  }
}

class TopMarketsTable extends Component {

  render () {
    const markets = topMarkets.map((market, key) => {
      return (
        <tr key={key} href="#">
          <td>{market.name}</td>
          <td>{market.cap}</td>
        </tr>
      )
    });
    return (
      <table>
        <thead>
          <tr>
            <th colSpan="999">Top Markets</th>
          </tr>
        </thead>
        <tbody>
          {markets}
        </tbody>
      </table>
    );
  }
}

class App extends Component {
  constructor (props) {
    super(props)
    this.state = {
      searchTerm: ''
    }
    this.searchUpdated = this.searchUpdated.bind(this)
  }

  getAvailableCurrencies = (markets) => {
    return _.chain(markets)
            .map('currency')
            .uniq()
            .value();
  }

  render () {
    const filteredMarkets = this.state.searchTerm
    ? data.filter(createFilter(this.state.searchTerm, KEYS_TO_FILTERS))
    : [];

    const topTables = (
      <div className="row">
        <div className="col-md-6">
          <TopCoinsTable onClickCoin={this.searchUpdated} />
        </div>
        <div className="col-md-6">
          <TopMarketsTable />
        </div>
    </div>
    );

    const table = filteredMarkets.map((item, key) => {

      let currencies = this.getAvailableCurrencies(item.markets);
      let markets = item.markets.map((market, key) => {

        let marketCurrency = currencies.map((currency, key) => {
          let status = market.currency.indexOf(currency) >= 0
            ? 'check'
            : 'cross';
            return(
                <td className="marketCurrency">
                  <div className={status}></div>
                </td>
            );
        });

        return (
          <tr key={key}>
            <td className="marketName">{market.name}</td>
            {marketCurrency}
            <td className="marketUrl text-right">
              <a className="btn" href="{market.url}">buy {item.name}</a>
            </td>
          </tr>
        );
      });

      const currencyHeaders = currencies.map((currency, key) => {
        return <th key={key} className="smaller">{currency}</th>
      });

      return (
        <table key={key}>
          <thead>
            <tr>
              <th>{item.name} [{item.code}]</th>
              {currencyHeaders}
              <th></th>
            </tr>
          </thead>
          <tbody>
            {markets}
          </tbody>
        </table>
      )
    })

    const content = filteredMarkets.length > 0
      ? table
      : topTables;

    const filledClass = filteredMarkets.length > 0 ? 'filled' : '';
    const classes = `finder ${filledClass}`;

    return (
      <div className={classes}>
        <div className="d-sm-flex justify-content-center input-area">
          <h1>Where to buy </h1>
          <SearchInput className="search-input" onChange={this.searchUpdated} placeholder=" " value={this.state.searchTerm} />
        </div>
        {content}
      </div>
    )
  }

  searchUpdated (term) {
    this.setState({searchTerm: term})
  }
}

export default App;
