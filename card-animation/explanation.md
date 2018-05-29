## Goal

To have cards move around the game table in a realistic way to simulate a live custom card game.

## Initial Approach

Use simple web components, `<pilatch-card>` elements in this case. No attempt at browser compatibility outside Chrome is made at this point, though even IE 11 can be supported.

Have each card element be a child of the same parent, table-top element. The table-top element's style is `position: relative`. Each pilatch-card child element's style is `position: absolute`.

Use CSS classes to drive the animations. For instance to move a card from a player's hand to the placed-card-area we would add that CSS class and remove the "hand" class from that pilatch-card element.

## Problem
