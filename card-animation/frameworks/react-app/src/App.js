import React, { Component } from 'react';
import './App.css';

class App extends React.Component {
  constructor() {
    super()
    this.state = {
      placedCardIndex: -1
    }
    setInterval(() => {
      this.setState({
        placedCardIndex: this.state.placedCardIndex === 4
          ? 0
          : this.state.placedCardIndex + 1
      })
    }, 1250)
  }

  render() {
    return (
      <main>
        <div class="table-top">
          <Hand placed={this.state.placedCardIndex}/>
          <pilatch-card nothing class="player-placed-card-area"></pilatch-card>
        </div>
      </main>
    );
  }
}

class Hand extends Component {
  render() {
    return (
      [0,1,2,3,4].map(index => {
        let cssClass = `player-hand hand-size-5 card-${index} ${
          this.props.placed === index
            ? 'player-placed-card-area'
            : ''
        }`
        return <pilatch-card suit="rock" rank={index + 1} up class={cssClass}></pilatch-card>
      })
    )
  }
}

export default App;
