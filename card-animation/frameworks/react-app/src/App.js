import React, { Component } from 'react';
import './App.css';

class App extends React.Component {
  constructor() {
    super()
    this.state = {
      placedIndex: -1,
      placedCard: null,
    }
    setInterval(() => {
      this.setState({
        placedCard: null,
        placedIndex: this.state.placedIndex === 4
          ? 0
          : this.state.placedIndex + 1,
      })
      setTimeout(() => {
        this.setState({
          ...this.state,
          placedCard: {
            rank: this.state.placedIndex + 1,
            suit: 'rock',
          }
        })
      }, 1000)
    }, 1250)
  }

  render() {
    return (
      <section>
        <h1>React</h1>
        <main>
          <h2>deleting placed cards from hand</h2>
          <div class="table-top">
            <Hand placedIndex={this.state.placedIndex} placedCard={this.state.placedCard} removePlaced={true}/>
            <PlacedCardArea placedCard={this.state.placedCard} />
          </div>
        </main>
        <hr/>
        <main>
          <h2>duplicating placed cards in hand</h2>
          <div class="table-top">
            <Hand placedIndex={this.state.placedIndex} placedCard={this.state.placedCard}/>
            <PlacedCardArea placedCard={this.state.placedCard} />
          </div>
        </main>
      </section>
    )
  }
}

class PlacedCardArea extends Component {
  render() {
    let card = this.props.placedCard

    if (card) {
      return (
        <>
          <pilatch-card suit={card.suit} rank={card.rank} class="player-placed-card-area"></pilatch-card>
          <pilatch-card nothing class="player-placed-card-area"></pilatch-card>
        </>
      )
    } else {
      return <pilatch-card nothing class="player-placed-card-area"></pilatch-card>
    }
  }
}

class Hand extends Component {
  render() {
    let placedIndex = this.props.placedIndex
    let placedCard = this.props.placedCard
    let removePlaced = this.props.removePlaced

    if (placedIndex === -1) { // no placed card yet
      return [0,1,2,3,4].map(index => {
        let cssClass = `player-hand hand-size-5 card-${index}`
        return <pilatch-card suit="rock" rank={index + 1} up class={cssClass}></pilatch-card>
      })
    }

    return (
      [0,1,2,3,4].map(index => {
        if (placedCard && index === placedIndex && removePlaced) {
          return null
        }

        let adjustedHandIndex = placedIndex > index
          ? index
          : index - 1
        let cssClass = `player-hand hand-size-5 card-${adjustedHandIndex} ${
          placedIndex === index
            ? 'player-placed-card-area'
            : ''
        }`
        return <pilatch-card suit="rock" rank={index + 1} up={index === placedIndex ? null : true} class={cssClass}></pilatch-card>
      }).filter(Boolean)
    )
  }
}

export default App;
